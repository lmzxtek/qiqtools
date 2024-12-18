'''
免费节点获取服务


'''
from flask import Flask, request, jsonify, send_from_directory, request, abort
from pathlib import Path

# 爬取米贝节点
import os
import requests
from bs4 import BeautifulSoup


app = Flask(__name__)

HOST  = "localhost"
PORT  = 5003
DEBUG = False
FLD_DATA = 'data_year'

# 指定文件根目录
BASE_DIRECTORY = Path(FLD_DATA).resolve()

# 检查文件根目录是否存在，如果不存在则创建
BASE_DIRECTORY.mkdir(parents=True, exist_ok=True)
with open(f'{FLD_DATA}/test.txt', 'w') as file:
    file.write('This is a file for url request test.')

@app.route('/download/<path:filepath>', methods=['GET'])
def download_file(filepath):
    # 将请求路径拼接到根目录，确保路径合法
    file_path = (BASE_DIRECTORY / filepath).resolve()

    # 确保文件路径在根目录内，防止目录遍历攻击
    if not file_path.is_file() or BASE_DIRECTORY not in file_path.parents:
        abort(404)  # 文件未找到则返回404错误

    # 返回文件下载
    return send_from_directory(BASE_DIRECTORY, filepath, as_attachment=True)

# 文件上传（可选），允许将文件上传到服务器的子目录
@app.route('/upload/<path:filepath>', methods=['POST'])
def upload_file(filepath):
    if 'file' not in request.files:
        return "No file part", 400

    file = request.files['file']
    if file.filename == '':
        return "No selected file", 400

    # 将上传的文件保存到指定的子目录
    upload_path = (BASE_DIRECTORY / filepath).resolve()
    if BASE_DIRECTORY not in upload_path.parents:
        abort(403)  # 禁止访问超出根目录的路径

    # 创建子目录（如果不存在）
    upload_path.parent.mkdir(parents=True, exist_ok=True)

    # 保存文件
    file.save(upload_path)
    return "File uploaded successfully", 200

def get_urls(url):
    '''     获取链接中的文章的子链接     '''
    # 发送HTTP请求获取网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"main"的<div>元素
    main_div = soup.find("div", id="main")

    # 查找所有<article>元素
    articles = main_div.find_all("article")

    links = []
    # 打印找到的<article>元素
    for article in articles:
        link = article.find("a")
        if link: 
            # 获取链接的hre属性
            href = link.get("href")
            links.append(href)
            # print(href)
            
    return links 

def get_sub(url):
    """
    查找链接中网页的v2ray和clash订阅地址

    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
    """
    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"post-body"的<div>元素
    post_body_div = soup.find("div", id="post-body")

    # 查找<div>元素内的所有<p>元素
    paragraphs = post_body_div.find_all("p")

    urlv2ray = ''
    urlclash = ''
    
    # 遍历<p>元素
    for paragraph in paragraphs:
        # 获取<p>元素的文本内容
        text = paragraph.get_text()

        # 判断文本内容是否符合条件
        if text.endswith(".txt"):
            urlv2ray = text 
        if text.endswith(".yaml"):
            urlclash = text 
            
    return urlv2ray,urlclash

def download_file(url, filename):
    '''下载链接中的文件，并将其保存为filename定义的文件名'''
    response = requests.get(url)
    if response.status_code == 200:
        with open(filename, "wb") as file:
            file.write(response.content)
        # print("文件已成功下载并保存为", filename)
    else:
        print("无法访问链接:", url)        

@app.route('/get_current', methods=['GET'])
def route_get_current_data():
    
    symbols = request.args.get('symbols')
    
    if not symbols: return jsonify({'error': 'symbols is a required parameters'}), 400
    
    symbols = symbols.replace('SE.','SE').replace('SE','SE.')
    
    # try:
    #     data = current(symbols=symbols)
    #     return data 
    # except Exception as e:
    #     return jsonify({'error': str(e)}), 500
    
#=================================================
if __name__ == '__main__':
    # usage_info(DEBUG)
    app.run(host=HOST,port=PORT,debug=DEBUG)
    
    
# if __name__ == '__main__':
#     url = "https://www.mibei77.com"  # 替换为您要访问的网页的URL
    
#     links = get_urls(url)
#     print("The latest link is :",links[0])

#     uv,uc = get_sub(links[0])
#     print("Subscript of v2ray: ", uv)
#     print("Subscript of clash: ", uc)
    
#     # 检查文件是否已存在，如果存在则删除
#     if os.path.exists(uv):
#         os.remove(uv)
        
#     if os.path.exists(uc):
#         os.remove(uc)
        
#     download_file(uv,'mibei-v2ray.txt')
#     download_file(uc,'mibei-clash.yaml')