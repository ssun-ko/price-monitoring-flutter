import os
import csv
import subprocess
import urllib
import requests
from datetime import datetime, timedelta
from urllib.parse import urlparse
from bs4 import BeautifulSoup

# 환경 변수에서 API 키 가져오기
KOREA_BANK_API_KEY = os.getenv("KOREA_BANK_API_KEY")
LME_PRICE_URL = os.getenv("LME_PRICE_URL")
OPINET_API_KEY = os.getenv("OPINET_API_KEY")
PUBLIC_DATA_CENTER_API_KEY = os.getenv("PUBLIC_DATA_CENTER_API_KEY")

# 중복이 아니면 True, 중복값이면 False 반환
def date_today_duplicate_check(file_path, file_name, today_date):
    try:
        with open(f"{file_path}/{file_name}", mode='r', newline='', encoding='utf-8-sig') as file:
            last_row = list(csv.reader(file))[-1]
            if last_row[0] == today_date:
                print(f"{file_name}의 데이터가 {today_date} 일자에 중복")
                return False
        print(f"{today_date} 일자의 {file_name} 데이터 수집 시작")
        return True
    except FileNotFoundError:
        print(f"{file_name}이(가) 존재하지 않아 새로 만듭니다.")
        return True 
    except Exception as e:
        print(f"날짜 중복 체크 중 에러 발생: {e}")
        return False


# Requests를 통한 데이터 가져오기
def fetch_data(url, params=None, encoding=None):
    try:
        if params:
            params = urllib.parse.urlencode(params, safe='#\':()+%=').encode('utf-8')
        response = requests.get(url, params=params, timeout=5)
        response.encoding = encoding if encoding else response.apparent_encoding
        if response.status_code == 200:
            print(f"url 주소 읽어오기 완료")
            return response
        else:
            raise Exception(f"url 주소 읽어오기 실패")
    except Exception as e:
        print(f"데이터 가져오기 중 에러 발생: {e}")
        return None


# 날짜 포맷 변환 함수
def format_date(date, input_format, output_format):
    return datetime.strptime(date, input_format).strftime(output_format)


# 데이터 초기화 함수
def initialize_data():
    return {
        'no_metal_prices': {'일자': None, '구리': None, '알루미늄': None, '아연': None, '납': None, '니켈': None, '주석': None},
        'dollar_won_rate': {'일자': None, '환율': None},
        'oil_price': {'일자': None, '전국': None, '서울': None, '경기': None, '인천': None, '강원': None, '충북': None, '충남': None, '전북': None, '전남': None, '경북': None, '경남': None, '세종': None, '대전': None, '대구': None, '부산': None, '광주': None, '울산': None, '제주': None},
        'metal_price': []
    }


# 한국은행경제통계시스템에서 달러/원 환율 가져오기
def korea_bank(dollar_rate, date):
    try:
        url_head = "http://ecos.bok.or.kr/api/StatisticSearch"
        exchange_rate_code = "731Y001"
        formatted_date = format_date(date, '%Y-%m-%d', '%Y%m%d')
        url_tail = f"{KOREA_BANK_API_KEY}/json/kr/1/10/{exchange_rate_code}/D/{formatted_date}/{formatted_date}"
        data = fetch_data(f"{url_head}/{url_tail}").json()
        rdata = data['StatisticSearch']["row"][0]
        dollar_rate['환율'] = rdata['DATA_VALUE']
        dollar_rate['일자'] = format_date(rdata['TIME'], "%Y%m%d", "%Y-%m-%d")
        print(f"한국은행 Open API로 환율 데이터 가져오기 완료, 날짜: {dollar_rate['일자']}")
    except Exception as e:
        print(f"한국은행 데이터 가져오기 중 에러 발생: {e}")


# LME 데이터 가져오기
def lme_price(prices):
    try:
        html = fetch_data(LME_PRICE_URL).text
        soup = BeautifulSoup(html, 'html.parser')
        td_elements = soup.find('div', class_="sub_page").find_all('td')
        prices['일자'] = td_elements[0].text.replace(". ", "-")
        for metal, idx in zip(['구리', '알루미늄', '아연', '납', '니켈', '주석'], range(1, 7)):
            prices[metal] = float(td_elements[idx].text.replace(",", ""))
        print(f"LME 비철금속 데이터 가져오기 완료, 날짜: {prices['일자']}")
    except Exception as e:
        print(f"LME 데이터 가져오기 중 에러 발생: {e}")


# 오피넷 데이터 가져오기
def opinet_oil(prices):
    try:
        base_url = "http://www.opinet.co.kr/api/"
        # 유가 정보 날짜 가져오기
        url = f"{base_url}avgAllPrice.do"
        params = {"out": "json", "code": OPINET_API_KEY}
        oil_data = fetch_data(url, params).json()['RESULT']['OIL']
        prices['일자'] = format_date(oil_data[0]['TRADE_DT'], "%Y%m%d", "%Y-%m-%d")
        # 전국 지역별 유가 정보 가져오기
        url = f"{base_url}avgSidoPrice.do"
        params.update({"prodcd": "D047"})
        oil_datas = fetch_data(url, params).json()['RESULT']['OIL']
        for oil_data in oil_datas:
            sido = oil_data['SIDONM']
            if sido in prices:
                prices[sido] = oil_data['PRICE']
            else:
                print(f"입력되지 않은 지역 {sido}이 있습니다")
        print(f"Opinet API로 유가 데이터 가져오기 완료, 날짜: {prices['일자']}")
    except Exception as e:
        print(f"Opinet 데이터 가져오기 중 에러 발생: {e}")


# 공공 데이터 포탈 데이터 가져오기
def public_data_center(prices):
    try:
        url = "http://api.odcloud.kr/api/3039951/v1/uddi:b6699de8-3b19-4ab7-8ed7-894636ad6c6d_202004071625"
        params = {"page": "1", "perPage": "200", "returnType": "json", "serviceKey": PUBLIC_DATA_CENTER_API_KEY}
        data = fetch_data(url, params).json()
        last_date = data['data'][0]['기간']
        for i in data['data']:
            prices_entry = {
                '날짜': i['기간'] + "-01",
                '철근 (천원/톤)': i['철근(천원_톤)'],
                '철광석 (달러/톤)': i['철광석(달러_톤)'],
                '유연탄 (달러/톤)': i['유연탄(달러_톤)'],
                '스크랩 (달러/톤)': i['철스크랩(달러_톤)']
            }
            prices.append(prices_entry)
        print(f"공공데이터포탈 API로 철강원자재 데이터 가져오기 완료\n 업데이트 최종 날짜: {last_date}")
    except Exception as e:
        print(f"공공데이터포탈 데이터 가져오기 중 에러 발생: {e}")


# CSV 파일에 새로운 행 추가
def append_row_to_csv(file_path, file_name, data):
    try:
        with open(f"{file_path}/{file_name}", mode='a', newline='', encoding='utf-8-sig') as file:
            writer = csv.writer(file)
            writer.writerow(data.values())
        print(f"{file_name}에 새 행 추가 완료")
    except Exception as e:
        print(f"CSV 파일에 행 추가 중 에러 발생: {e}")


# CSV 파일 쓰기
def write_to_csv_file_metal(file_path, file_name, data):
    try:
        with open(f"{file_path}/{file_name}", mode='w', newline='', encoding='utf-8-sig') as file:
            writer = csv.DictWriter(file, fieldnames=data[0].keys())
            writer.writeheader()
            for row in data:
                writer.writerow(row)
        print(f"{file_name}에 CSV 데이터 쓰기 완료")
    except Exception as e:
        print(f"CSV 파일 쓰기 중 에러 발생: {e}")


# Git 저장소에서 최신 정보 가져오기
def git_pull(repo_path):
    # 작업 디렉토리를 Git 저장소 디렉토리로 변경
    os.chdir(repo_path)
    
    # 최신 정보 가져오기
    subprocess.run(["git", "pull"], check=True)
    print("Git 저장소에서 최신 정보 가져오기 완료")


# Git 저장소에 변경 사항 커밋 및 푸쉬
def git_commit_and_push(repo_path, commit_message):
    try:
        # 작업 디렉토리를 Git 저장소 디렉토리로 변경
        os.chdir(repo_path)

        # 변경 사항 확인
        status_output = subprocess.check_output(["git", "status", "--porcelain"]).decode().strip()
        if status_output:
            subprocess.run(["git", "config", "user.name", "ko-hoon"], check=True)
            subprocess.run(["git", "config", "user.email", "seunghoon_jeon@kolon.com"], check=True)
            subprocess.run(["git", "add", "."], check=True)
            subprocess.run(["git", "commit", "-m", commit_message], check=True)

            # 환경 변수에서 GH_TOKEN을 가져옴
            token = os.getenv('GH_TOKEN')
            if not token:
                raise Exception("GH_TOKEN이 설정되지 않았습니다.")

            # 리모트 URL에 토큰 추가 (origin 대신 실제 리모트 이름을 사용)
            remote_url = subprocess.check_output(["git", "config", "--get", "remote.origin.url"]).decode().strip()
            token_url = remote_url.replace("https://", f"https://{token}@")

            # 리모트 URL 업데이트
            subprocess.run(["git", "remote", "set-url", "origin", token_url], check=True)
            subprocess.run(["git", "push"], check=True)
            print("변경 사항을 Git 저장소에 커밋 및 푸쉬 완료")
        else:
            print("변경 사항이 없어 커밋 및 푸쉬를 생략합니다.")
    except subprocess.CalledProcessError as e:
        print(f"Git 커밋 및 푸쉬 중 에러 발생: {e}")
    except Exception as e:
        print(f"Git 작업 중 에러 발생: {e}")


# 메인 함수
def main():
    # 데이터 파일 경로 및 파일명 지정
    repo_path = "./"  # Git 저장소 경로
    write_file_path = os.path.join(repo_path, "data")
    dollar_won_rate_filename = "dollar_won_rate_data.csv"
    no_metal_filename = "daily_no_metal_data.csv"
    oil_price_filename = "daily_oil_data.csv"
    metal_price_filename = "monthly_metal_data.csv"

    # Git 저장소 최신화
    # git_pull(repo_path)

    # 현재 날짜 및 이전 영업일 계산
    today = datetime.today()
    formatted_today = today.strftime('%Y-%m-%d')
    previous_business_day = today - timedelta(days=3) if today.weekday() == 0 else today - timedelta(days=1)
    formatted_previous_business_day = previous_business_day.strftime('%Y-%m-%d')

    # 데이터 초기화
    data = initialize_data()

    # 각 데이터 수집 및 CSV 파일에 추가
    if date_today_duplicate_check(write_file_path, dollar_won_rate_filename, formatted_today):
        korea_bank(data['dollar_won_rate'], formatted_today)
        append_row_to_csv(write_file_path, dollar_won_rate_filename, data['dollar_won_rate'])

    if date_today_duplicate_check(write_file_path, oil_price_filename, formatted_today):
        opinet_oil(data['oil_price'])
        append_row_to_csv(write_file_path, oil_price_filename, data['oil_price'])

    if date_today_duplicate_check(write_file_path, no_metal_filename, formatted_previous_business_day):
        lme_price(data['no_metal_prices'])
        append_row_to_csv(write_file_path, no_metal_filename, data['no_metal_prices'])

    public_data_center(data['metal_price'])
    write_to_csv_file_metal(write_file_path, metal_price_filename, data['metal_price'][::-1])

    # 변경 사항을 Git 저장소에 커밋 및 푸쉬
    git_commit_and_push(repo_path, f"데이터 업데이트: {formatted_today}")


if __name__ == "__main__":
    main()
