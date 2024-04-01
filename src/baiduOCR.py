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
            output2txt(word_info["words"])
    else:
        print("OCR failed.")


def inputAllIMG2OCR(api_key, secret_key, folder_path):
    # 定义图片文件的扩展名
    image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp']

    # 遍历文件夹下的所有文件
    for filename in os.listdir(folder_path):
        # 获取文件的完整路径
        file_path = os.path.join(folder_path, filename)
        # 检查文件是否是图片文件
        if os.path.isfile(file_path) and any(filename.lower().endswith(ext) for ext in image_extensions):
            # 处理图片文件，这里可以加入你的逻辑
            print("Found image file:", file_path) 
        baidu_ocr_handwriting(api_key, secret_key, file_path)  

    print("=====================") 
    print("所有图片都处理完了！")  
    print("=====================")    

def inputConfig():
    api_key = None
    secret_key = None

    configfile_path = R'config/BaiduOCRKey.txt'
    try:
        with open(configfile_path, 'r') as file:
            #content = file.read()
            for line in file:
                if line.startswith('api_key:'):
                    # 获取目标字段后面的内容并去除首尾空格
                    api_key = line[len('api_key:'):].strip()
                    print(f"匹配到api_key，值为: {api_key}")                    
                if line.startswith('secret_key:'):
                    # 获取目标字段后面的内容并去除首尾空格
                    secret_key = line[len('secret_key:'):].strip()
                    print(f"匹配到secret_key，值为: {secret_key}")                     
    except FileNotFoundError:
        print(f"文件 '{configfile_path}' 不存在。")
    except IOError:
        print(f"无法读取文件 '{configfile_path}'。")

    return api_key, secret_key

def output2txt(words):
    # 打开文件，如果文件不存在则创建它，使用追加写入模式（'a'）
    #指定utf-8编码, 防止默认的GBK无法编译
    file_path = R'output/result.md'
    with open(file_path, 'a', encoding='utf-8') as f:
        # 写入文本到文件
        f.write(F'{words}')  


if __name__ == "__main__":
    # 替换成你在百度开发者平台创建应用获得的 API Key 和 Secret Key
    api_key, secret_key = inputConfig() 

    # 替换成你要识别的图片路径
    image_path = "C:\\Users\\zxb29\\Desktop\\图片\\_20240213222517.jpg"
    #image_path = R"C:\Users\zxb29\Desktop\OCR Photo\IMG_9001.JPG"

    # 验证文件是否存在
    if os.path.isfile(image_path):
        print(f"文件 '{image_path}' 存在.")
    else:
        print(f"文件 '{image_path}' 不存在.")

    baidu_ocr_handwriting(api_key, secret_key, image_path)
