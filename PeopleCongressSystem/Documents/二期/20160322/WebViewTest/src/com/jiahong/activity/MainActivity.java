package com.jiahong.activity;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.http.client.ClientProtocolException;
import org.json.JSONException;
import org.json.JSONObject;

import com.lnca.LNCAReq;
import com.jiahong.activity.JavaScriptinterface;

import android.app.Activity;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.StrictMode;
import android.util.Base64;
import android.util.Log;
import android.webkit.WebView;

public class MainActivity extends Activity {
	
	private WebView webv = null;
	public Handler handler = new Handler(); 

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		webv =(WebView)findViewById(R.id.webView1);//从xml中获取webview
		
		webv.getSettings().setJavaScriptEnabled(true);//允许JS执行
		
		webv.addJavascriptInterface(new JavaScriptinterface(this), "android");
		
		webv.getSettings().setDomStorageEnabled(true);
		
		webv.getSettings().setDefaultTextEncodingName("UTF-8");//设置字符集编码  
		
		webv.addJavascriptInterface(this, "loginInterface");

        webv.loadUrl("file:///android_asset/index.html");
        
        StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()  
		        .detectDiskReads()  
		        .detectDiskWrites()  
		        .detectNetwork()  
		        .penaltyLog()  
		        .build());   
		StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder()  
		        .detectLeakedSqlLiteObjects()  
		        .detectLeakedClosableObjects()  
		        .penaltyLog()  
		        .penaltyDeath()  
		        .build());  
        
	}
	
	public void login(final String id,final String pwd){
 
        handler.post(new Runnable() {  
            
            public void run() {  
            	try {
            		JSONObject object = new JSONObject();
            		//数据库所在位置
					String path = Environment.getExternalStorageDirectory()
							.getAbsolutePath() + "/data/lnca/libs/";
					
					LNCAReq req = new LNCAReq();
					//初始化带路径（注：请勿使用此例子以外的其他方法）
					int nRet = req.InitwithPath(path);

					if(nRet==0)
					{
						//验证密码
						nRet=req.CheckPIN(pwd.getBytes());
						if(nRet==0)
						{
							//查询数据库里的证书个数
							nRet=req.GetCertNum();
							if(nRet>0)
							{								
								nRet = req.GetCertByid(id.getBytes(), 1);
								
								if(nRet==0)
								{									
									String url = "http://218.25.86.214:2010/ssoworker";
									String parms = "cmd=getrand";
									String outResult = "rand";
									
									
									//随机数
									String strSignData = sendPostWithParmsAndGetResult(url,parms,outResult);
									
									//签名
									nRet = req.SignData(req.bytecert, strSignData.getBytes());
									
									if(nRet==0)
									{
										//证书base64
										String certBase64 = Base64.encodeToString(req.bytecert, Base64.NO_WRAP);
	
										//签名结果转成base64
										String signedBase64 = Base64.encodeToString(req.bytesigned, Base64.NO_WRAP);
										
										
										parms = "cmd=certlogin";
										parms += "&cert=";
										parms += URLEncoder.encode(certBase64,"utf-8");
										parms += "&rand=";
										parms += strSignData;
										parms += "&signed=";
										parms += URLEncoder.encode(signedBase64,"utf-8");
										
										outResult = "token";
										
										String token = sendPostWithParmsAndGetResult(url,parms,outResult);
										
										if(token!=null && token !="")
										{
											object.put("isSuccess", 1);
											object.put("message", "登录成功");
											object.put("cert", certBase64);
											object.put("rand", strSignData);
											object.put("signed", signedBase64);
											object.put("token", token);
										}else
										{
											object.put("isSuccess", 0);
											object.put("message", "登录失败");
										}
										
									}else
									{
										object.put("isSuccess", 0);
										object.put("message", "签名失败");
									}
									
								}else
								{
									object.put("isSuccess", 0);
									object.put("message", "获取证书信息失败");
								}
								
							}else
							{
								object.put("isSuccess", 0);
								object.put("message", "证书为空");
							}
						}else
						{
							object.put("isSuccess", 0);
							object.put("message", "密码错误");
						}
					}else
					{
						object.put("isSuccess", 0);
						object.put("message", "初始化失败");
					}
					
					//调用客户端loginRep方法  
					webv.loadUrl("javascript:loginRep('" + object.toString() + "')");
				} catch (Exception e) {
					// TODO: handle exception
					String msg=e.getMessage();
					Log.d("st", msg);
				}  
            }  
        });  

    }
	
	public  String sendPostWithParmsAndGetResult(String url, String params,String outResult) throws JSONException {
		
		String Result = "";
		HttpURLConnection Conn;
		try {
			URL verifyBindUrl = new URL(url);
			Conn = (HttpURLConnection) verifyBindUrl.openConnection();
			Conn.setRequestMethod("POST");// 提交模式
			Conn.setConnectTimeout(3000);// 连接超时 单位毫秒
			Conn.setReadTimeout(3000);// 读取超时 单位毫秒
			Conn.setDoOutput(true);// 是否输入参数
			byte[] bypes = params.toString().getBytes();
			Conn.getOutputStream().write(bypes);// 输入参数
			if (Conn.getResponseCode() == 200) {
				InputStream inStream = Conn.getInputStream();
				ByteArrayOutputStream outStream = new ByteArrayOutputStream();
				byte[] buffer = new byte[1024];
				int len = 0;
				while ((len = inStream.read(buffer)) != -1) {
					outStream.write(buffer, 0, len);
				}
				inStream.close();
				byte[] data = outStream.toByteArray();
				if (outStream != null) {
					outStream.close();
				}
				String json = new String(data);
				
				JSONObject jsonObject = new JSONObject(json);
				Result = jsonObject.get(outResult).toString();

			}
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return Result;
	}
	
	//取cn
	private String getSubjectCN(String subject) {
		int indexCN = subject.indexOf("CN=");
		int indexDH = subject.indexOf(",");
		String cn = "";
		if (indexCN >= 0) {
			if (indexDH > indexCN)
				cn = subject.substring(indexCN + 3, indexDH);
			else
				cn = subject.substring(indexCN + 3);
		}
		return cn;
	}

	//取得有效期
	private String getDateStr(String date) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
		ParsePosition pos = new ParsePosition(0);
		Date strtodate = formatter.parse(date, pos);
		return strtodate.toLocaleString();
	}
}
