# 爬取长风节点
import os
import re 
import requests
from bs4 import BeautifulSoup

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
    # articles = main_div.find_all("article")
    # 查找所有<h2>元素
    articles = main_div.find_all("h2")

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

def extract_url_from_string(string):
    """ 
    提取字符串中的url链接
    """
    pattern = r'(https?://\S+)'
    match = re.search(pattern, string)
    if match:
        return match.group(1)
    else:
        return None
    
    
def get_sub(url):
    """
    查找链接中网页的v2ray和clash订阅地址

    返回:
        字符串数组: v2ray订阅链接, clash订阅链接
    """

    base64ss = ''
    urlv2ray = ''
    urlclash = ''
    urlcmeta = ''
    urlsb    = ''
    restxt   = []

    # 发送HTTP请求获取链接对应的网页内容
    response = requests.get(url)
    html_content = response.content

    # 使用BeautifulSoup解析网页内容
    soup = BeautifulSoup(html_content, "html.parser")

    # 查找id为"post-body"的<div>元素
    post_body_div = soup.find("div", id="post-body")

    # 查找post-body元素内的所有<div>元素
    divs = post_body_div.find_all("div")
    base64_pre = post_body_div.find("pre", cid="n0").find("span")
    base64ss = base64_pre.get_text()

    # 遍历<div>元素
    for div in divs:
        # 获取<div>元素的文本内容
        text = div.get_text()

        # 判断文本内容是否符合条件
        if text.endswith(".txt"):
            restxt.append(text)
        if text.endswith(".yaml"):
            restxt.append(text)
        if text.endswith(".json"):
            restxt.append(text)
            
    urlv2ray = extract_url_from_string(restxt[2])        
    urlcmeta = extract_url_from_string(restxt[3])        
    urlclash = extract_url_from_string(restxt[4])        
    urlsb    = extract_url_from_string(restxt[5])       
    
    return base64ss, urlv2ray,urlclash,urlcmeta,urlsb

def download_file(url, filename):
    '''下载链接中的文件，并将其保存为filename定义的文件名'''
    response = requests.get(url)
    if response.status_code == 200:
        with open(filename, "wb") as file:
            file.write(response.content)
        # print("文件已成功下载并保存为", filename)
    else:
        print("无法访问链接:", url)        

if __name__ == '__main__':
    url = "https://www.cfmem.com/"  # 替换为您要访问的网页的URL
    
    links = get_urls(url)
    print("The latest link is :",links[0])

    ss,uv,uc,um,sb = get_sub(links[0])
    
    # print("Subscript of Base64: ", ss)
    print("Subscript of  v2ray: ", uv)
    print("Subscript of  clash: ", uc)
    print("Subscript of clashm: ", um)
    print("Subscript of clashm: ", sb)
    
    # with open('cfmen-bas64.txt', 'w') as file:
    #     file.write(ss) 
        
    download_file(uv,'cfmen-v2ray.txt')
    download_file(uc,'cfmen-clash.yaml')
    download_file(um,'cfmen-clashm.yaml')
    download_file(sb,'cfmen-singbox.json')