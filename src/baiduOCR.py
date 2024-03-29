import os
import requests
from base64 import b64encode

def baidu_ocr_handwriting(api_key, secret_key, image_path):
    # 获取访问令牌
    token_url = "https://aip.baidubce.com/oauth/2.0/token"
    token_params = {
        "grant_type": "client_credentials",
        "client_id": api_key,
        "client_secret": secret_key,
    }

    token_response = requests.post(token_url, params=token_params)
    access_token = token_response.json()["access_token"]

    # 手写文字识别 API 接口地址
    ocr_url = "https://aip.baidubce.com/rest/2.0/ocr/v1/handwriting"
    
    # 读取图片文件
    with open(image_path, "rb") as f:
        image_data = b64encode(f.read()).decode("utf-8")

    # 设置请求头
    headers = {
        "Content-Type": "application/x-www-form-urlencoded",
    }

    # 设置请求参数
    ocr_params = {
        "access_token": access_token,
        "image": image_data,
    }

    # 发送 POST 请求
    ocr_response = requests.post(ocr_url, headers=headers, data=ocr_params)

    # 解析结果
    result = ocr_response.json()
    if "words_result" in result:
        for word_info in result["words_result"]:
            print(word_info["words"])
    else:
        print("OCR failed.")

if __name__ == "__main__":
    # 替换成你在百度开发者平台创建应用获得的 API Key 和 Secret Key
    api_key = ""
    secret_key = ""

    # 替换成你要识别的图片路径
    image_path = "C:\\Users\\zxb29\\Desktop\\图片\\_20240213222517.jpg"

    # 验证文件是否存在
    if os.path.isfile(image_path):
        print(f"文件 '{image_path}' 存在.")
    else:
        print(f"文件 '{image_path}' 不存在.")


    baidu_ocr_handwriting(api_key, secret_key, image_path)
