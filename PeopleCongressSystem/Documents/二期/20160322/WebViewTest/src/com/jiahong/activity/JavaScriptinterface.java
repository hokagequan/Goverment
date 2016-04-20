package com.jiahong.activity;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

import org.json.JSONArray;
import org.json.JSONObject;

import com.lnca.LNCAReq;
import android.app.Activity;
import android.content.Context;
import android.os.Environment;
import android.os.Handler;
import android.util.Base64;
import android.util.Log;

public class JavaScriptinterface {

	private Context mContext;
	private String ID;
	private String certBase64;
	private JSONArray newArray;
	public Handler handler = new Handler();
	// 这个一定要定义，要不在showToast()方法里没办法启动intent
	Activity activity;

	/** Instantiate the interface and set the context */
	public JavaScriptinterface(Context c) {
		mContext = c;
		activity = (Activity) c;
	}

	/** 与js交互时用到的方法，在js里直接调用的 */
	public JSONArray showToast() {
		try {
			JSONObject object = new JSONObject();
			// 数据库所在位置
			String path = Environment.getExternalStorageDirectory()
					.getAbsolutePath() + "/data/lnca/libs/";
			LNCAReq req = new LNCAReq();
			// 初始化带路径（注：请勿使用此例子以外的其他方法）
			int nRet = req.InitwithPath(path);
			if (nRet == 0) {
				// 查询数据库里的证书个数
				nRet = req.GetCertNum();
				if (nRet > 0) {
					// 获得证书id集合
					String idList = req.GetidList();
					JSONObject json = new JSONObject(idList);
					JSONArray array = json.getJSONArray("IDList");
					newArray = new JSONArray();
					// 取证书id，此处可以做成下拉列表让用户选择证书
					for (int i = 0; i < array.length(); i++) {
						String strID = "";
						JSONObject jsonObj = new JSONObject(array.get(i)
								.toString());
						strID = jsonObj.getString("id");

						nRet = req.GetCertByid(strID.getBytes(), 1);
						if (nRet == 0) {
							// 证书base64
							certBase64 = Base64.encodeToString(req.bytecert,
									Base64.NO_WRAP);
						}

						InputStream inStream = new ByteArrayInputStream(
								req.bytecert);
						String id = null;
						String info = null;
						String name = null;

						// 创建X509工厂类
						CertificateFactory cf = CertificateFactory
								.getInstance("X.509");
						// 创建证书对象
						X509Certificate oCert = (X509Certificate) cf
								.generateCertificate(inStream);

						id = jsonObj.getString("id");
						info = oCert.getSerialNumber().toString(16);
						name = getSubjectCN(jsonObj.getString("user"));

						jsonObj.put("id", id);
						jsonObj.put("certSN", info);
						jsonObj.put("name", name);

						newArray.put(jsonObj);

					}

				}
			}
		} catch (Exception e) {
			// TODO: handle exception
			String msg = e.getMessage();
			Log.d("st", msg);
		}
		return newArray;
	}

	// 去测cn
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
}
