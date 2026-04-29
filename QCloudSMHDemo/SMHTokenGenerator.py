#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
腾讯云智能媒资托管 - 访问令牌获取脚本
功能：通过 API 获取访问令牌并保存到文件
优化版本：域名作为必传参数
"""

import requests
import json
import argparse
import sys
import os
from datetime import datetime, timedelta
from typing import Dict, Optional, List
from urllib.parse import urlparse


class SMHTokenGenerator:
    """智能媒资托管令牌生成器"""
    
    def __init__(self):
        """初始化"""
        self.session = requests.Session()
        # 设置请求头
        self.session.headers.update({
            'Content-Type': 'application/json'
        })
        
    def validate_url(self, url: str) -> bool:
        """
        验证 URL 格式
        
        Args:
            url: 要验证的 URL
            
        Returns:
            bool: URL 是否有效
        """
        try:
            result = urlparse(url)
            return all([result.scheme, result.netloc])
        except Exception:
            return False
    
    def get_access_token(self, 
                        base_url: str,
                        library_id: str,
                        library_secret: str,
                        space_id: Optional[str] = None,
                        user_id: Optional[str] = None,
                        client_id: Optional[str] = None,
                        session_id: Optional[str] = None,
                        local_sync_id: Optional[str] = None,
                        period: int = 86400,
                        grant: Optional[str] = None,
                        allow_space_tag: Optional[str] = None,
                        post_data: Optional[Dict] = None) -> Dict:
        """
        获取访问令牌
        
        Args:
            base_url: API 基础地址
            library_id: 媒体库 ID
            library_secret: 媒体库密钥
            space_id: 空间 ID（多租户模式需要）
            user_id: 用户身份识别
            client_id: 客户端识别
            session_id: 会话 ID
            local_sync_id: 同步盘 ID
            period: 令牌有效时长（秒）
            grant: 授予的权限
            allow_space_tag: 空间标记
            post_data: POST 请求体数据
            
        Returns:
            API 响应数据
            
        Raises:
            ValueError: 参数验证失败
            Exception: API 请求失败
        """
        
        # 参数验证
        if not self.validate_url(base_url):
            raise ValueError(f"无效的 URL 格式: {base_url}")
        
        if not library_id or not library_secret:
            raise ValueError("library_id 和 library_secret 是必填参数")
        
        if period < 1200:
            print("⚠️  警告: period 参数小于 1200，将自动使用最小值 1200")
            period = 1200
        
        # 构建请求参数
        params = {
            "library_id": library_id,
            "library_secret": library_secret,
            "period": period
        }
        
        # 添加可选参数
        optional_params = {
            "space_id": space_id,
            "user_id": user_id,
            "client_id": client_id,
            "session_id": session_id,
            "local_sync_id": local_sync_id,
            "grant": grant,
            "allow_space_tag": allow_space_tag
        }
        
        for key, value in optional_params.items():
            if value is not None:
                params[key] = value
        
        # 构建完整 URL
        url = f"{base_url.rstrip('/')}/api/v1/token"
        
        try:
            # 根据是否有 post_data 选择请求方法
            if post_data:
                # POST 请求
                response = self.session.post(
                    url, 
                    params=params, 
                    json=post_data,
                    timeout=30
                )
            else:
                # GET 请求
                response = self.session.get(url, params=params, timeout=30)
            
            response.raise_for_status()
            
            result = response.json()
            
            # 验证响应结构
            if "accessToken" not in result:
                raise ValueError("API 响应缺少 accessToken 字段")
            
            # 添加获取时间信息
            current_time = datetime.now()
            result["obtained_at"] = current_time.isoformat()
            result["expires_at"] = (current_time + timedelta(seconds=result.get("expiresIn", period))).isoformat()
            result["request_params"] = {
                "base_url": base_url,
                "library_id": library_id,
                "library_secret": library_secret,
                "space_id": space_id,
                "user_id": user_id,
                "period": period
            }
            
            return result
            
        except requests.exceptions.RequestException as e:
            if hasattr(e, 'response') and e.response is not None:
                status_code = e.response.status_code
                try:
                    error_detail = e.response.json()
                except:
                    error_detail = e.response.text
                raise Exception(f"API 请求失败 (状态码: {status_code}): {error_detail}")
            else:
                raise Exception(f"网络请求失败: {str(e)}")
        except json.JSONDecodeError as e:
            raise Exception(f"响应解析失败: {str(e)}")
    
    def save_token_to_file(self,
                          token_data: Dict,
                          output_file: str,
                          format: str = "json") -> str:
        """
        将令牌保存到文件（优化版：JSON格式扁平化处理）
        
        Args:
            token_data: 令牌数据
            output_file: 输出文件路径
            format: 文件格式 (json/txt/env)
            
        Returns:
            保存的文件路径
        """
        
        # 确保目录存在
        output_dir = os.path.dirname(output_file)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir, exist_ok=True)
        
        # 根据格式选择处理逻辑
        if format.lower() == "json":
            # ✅ JSON格式：进行扁平化处理
            flattened_data = self._flatten_token_data(token_data)
            
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(flattened_data, f, ensure_ascii=False, indent=2)
                
        elif format.lower() == "env":
            # 环境变量格式（保持原有逻辑）
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(f"SMH_ACCESS_TOKEN={token_data.get('accessToken', '')}\n")
                f.write(f"SMH_EXPIRES_IN={token_data.get('expiresIn', '')}\n")
                f.write(f"SMH_OBTAINED_AT={token_data.get('obtained_at', '')}\n")
                f.write(f"SMH_EXPIRES_AT={token_data.get('expires_at', '')}\n")
                if token_data.get('request_params'):
                    params = token_data['request_params']
                    f.write(f"SMH_LIBRARY_ID={params.get('library_id', '')}\n")
                    f.write(f"SMH_BASE_URL={params.get('base_url', '')}\n")
                    
        else:
            # 文本格式（保持原有逻辑）
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write("=" * 50 + "\n")
                f.write("腾讯云智能媒资托管 - 访问令牌信息\n")
                f.write("=" * 50 + "\n\n")
                f.write(f"Access Token: {token_data.get('accessToken', '')}\n")
                f.write(f"Expires In: {token_data.get('expiresIn', '')} 秒\n")
                f.write(f"Obtained At: {token_data.get('obtained_at', '')}\n")
                f.write(f"Expires At: {token_data.get('expires_at', '')}\n\n")
                
                if token_data.get('request_params'):
                    f.write("请求参数:\n")
                    params = token_data['request_params']
                    for key, value in params.items():
                        if value:  # 只显示有值的参数
                            f.write(f"  {key}: {value}\n")
        
        return os.path.abspath(output_file)

    def _flatten_token_data(self, token_data: Dict) -> Dict:
        """
        扁平化令牌数据，将嵌套的request_params提升到顶层
        
        Args:
            token_data: 原始令牌数据（可能包含嵌套）
            
        Returns:
            扁平化后的数据字典
        """
        # 创建副本避免修改原始数据
        flattened = token_data.copy()
        
        # 🔧 核心优化：扁平化处理
        if 'request_params' in flattened:
            request_params = flattened.pop('request_params')  # 移除嵌套字典
            flattened.update(request_params)  # 合并到顶层 [7](@ref)
        
        return flattened


def main():
    """主函数"""
    parser = argparse.ArgumentParser(
        description='获取腾讯云智能媒资托管访问令牌',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
使用示例:
  
  基本用法 (必要参数):
    python get_token.py --base_url https://smh.tencentcloudapi.com \\
                        --library_id "your_library_id" \\
                        --library_secret "your_library_secret" \\
                        --output_file "/path/to/token.json"
  
  完整参数示例:
    python get_token.py --base_url https://smh.tencentcloudapi.com \\
                        --library_id "smh_123456" \\
                        --library_secret "abcd1234efgh5678" \\
                        --output_file "/tmp/smh_token.json" \\
                        --space_id "space_789" \\
                        --user_id "user_001" \\
                        --client_id "web_client" \\
                        --period 7200 \\
                        --grant "upload_file,create_directory" \\
                        --format "json"
  
  保存为环境变量格式:
    python get_token.py --base_url https://smh.tencentcloudapi.com \\
                        --library_id "smh_123456" \\
                        --library_secret "abcd1234efgh5678" \\
                        --output_file "/tmp/smh_token.env" \\
                        --format "env"
        """
    )
    
    # 必要参数
    parser.add_argument('--base_url', required=True, 
                       help='API 基础地址 (例如: https://smh.tencentcloudapi.com)')
    parser.add_argument('--library_id', required=True, help='媒体库 ID')
    parser.add_argument('--library_secret', required=True, help='媒体库密钥')
    parser.add_argument('--output_file', required=True, 
                       help='令牌保存文件路径 (例如: /path/to/token.json)')
    
    # 可选参数
    parser.add_argument('--space_id', help='空间 ID (多租户模式需要)')
    parser.add_argument('--user_id', help='用户身份识别')
    parser.add_argument('--client_id', help='客户端识别')
    parser.add_argument('--session_id', help='会话 ID')
    parser.add_argument('--local_sync_id', help='同步盘 ID')
    parser.add_argument('--period', type=int, default=86400, 
                       help='令牌有效时长，单位秒 (默认: 86400, 最小: 1200)')
    parser.add_argument('--grant', help='授予的权限，多个权限用逗号分隔')
    parser.add_argument('--allow_space_tag', help='空间标记')
    parser.add_argument('--format', choices=['json', 'txt', 'env'], default='json',
                       help='输出文件格式 (默认: json)')
    
    # POST 请求相关参数
    parser.add_argument('--use_post', action='store_true',
                       help='使用 POST 方法代替 GET')
    parser.add_argument('--post_data', help='POST 请求体数据 (JSON 格式字符串)')
    
    args = parser.parse_args()
    
    # 创建令牌生成器
    generator = SMHTokenGenerator()
    
    try:
        print("🔐 正在获取腾讯云智能媒资托管访问令牌...")
        
        # 解析 POST 数据
        post_data = None
        if args.use_post and args.post_data:
            try:
                post_data = json.loads(args.post_data)
                print("📤 使用 POST 方法并携带请求体数据")
            except json.JSONDecodeError as e:
                raise ValueError(f"POST 数据格式错误: {str(e)}")
        elif args.use_post:
            print("📤 使用 POST 方法")
        
        # 获取访问令牌
        token_data = generator.get_access_token(
            base_url=args.base_url,
            library_id=args.library_id,
            library_secret=args.library_secret,
            space_id=args.space_id,
            user_id=args.user_id,
            client_id=args.client_id,
            session_id=args.session_id,
            local_sync_id=args.local_sync_id,
            period=args.period,
            grant=args.grant,
            allow_space_tag=args.allow_space_tag,
            post_data=post_data
        )
        
        # 保存到文件
        saved_path = generator.save_token_to_file(token_data, args.output_file, args.format)
        
        print("\n✅ 访问令牌获取成功！")
        print(f"📁 令牌已保存至: {saved_path}")
        print(f"⏰ 有效期: {token_data.get('expiresIn', '')} 秒")
        print(f"🕒 获取时间: {token_data.get('obtained_at', '')}")
        print(f"📅 过期时间: {token_data.get('expires_at', '')}")
        
        # 显示文件大小
        file_size = os.path.getsize(saved_path)
        print(f"📊 文件大小: {file_size} 字节")
        
    except Exception as e:
        print(f"\n❌ 错误: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
