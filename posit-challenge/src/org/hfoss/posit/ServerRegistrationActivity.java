/*******************************************************************************
 * Copyright (c) 2009 .
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the GNU Lesser Public License v2.1
 * which accompanies this distribution, and is available at
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 * 
 * Contributors:
 *     Prasanna Gautam - initial API and implementation
 *     Ralph Morelli - Supervisor
 *     Trishan deLanerolle - Director
 *     Antonio Alcorn - Summer 2009 Intern
 *     Gong Chen - Summer 2009 Intern
 *     Chris Fei - Summer 2009 Intern
 *     Phil Fritzsche - Summer 2009 Intern
 *     James Jackson - Summer 2009 Intern
 *     Qianqian Lin - Summer 2009 Intern 
 *     Khanh Pham - Summer 2009 Intern
 ******************************************************************************/

package org.hfoss.posit;

import java.util.List;

import org.hfoss.posit.web.Communicator;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

/**
 * Prompts the user to register their phone if the phone is not registered, or shows the phone's current 
 * registration status and allows the user to register their phone again with a different server.
 * 
 * @author Qianqian Lin
 *
 */
public class ServerRegistrationActivity extends Activity {

	private static final int BARCODE_READER = 0;
	private static final String TAG = "ServerRegistration";
	public boolean isSandbox = false; 

	/**
	 * Called when the Activity is first started.  If the phone is not registered, tells the user
	 * so and gives the user instructions on how to register the phone.  If the phone is registered, tells
	 * the user the server address that the phone is registered to in case the user would like to
	 * change it.
	 */
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		setContentView(R.layout.registration);
		
		SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(this);
		String server = sp.getString("SERVER_ADDRESS", null);
		
		if (server != null) {
			TextView notRegisteredTv = (TextView) findViewById(R.id.phoneNotRegistered);
			TextView registeredTv = (TextView) findViewById(R.id.phoneRegistered);
			TextView serverAddress = (TextView) findViewById(R.id.serverAddress);
			
			notRegisteredTv.setVisibility(View.GONE);
			registeredTv.setVisibility(View.VISIBLE);
			
			serverAddress.setVisibility(View.VISIBLE);
			serverAddress.setText(server);
		}
		final Button registerButton = (Button)findViewById(R.id.registerButton);
		final Button sandboxButton = (Button)findViewById(R.id.sandboxButton);
		final TextView barcodeError = (TextView)findViewById(R.id.barcodeReaderError);
		
		if(!isIntentAvailable(this,"com.google.zxing.client.android.SCAN")) {
			registerButton.setClickable(false);
			barcodeError.setVisibility(TextView.VISIBLE);
		}else{
			registerButton.setClickable(true);
			barcodeError.setVisibility(TextView.GONE);
		}
		registerButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	if (ServerRegistrationActivity.isIntentAvailable(
            			ServerRegistrationActivity.this,"com.google.zxing.client.android.SCAN"))
        		{
        			Intent intent = new Intent("com.google.zxing.client.android.SCAN");
        			try{
        				startActivityForResult(intent, BARCODE_READER);
        			}catch(ActivityNotFoundException e)
        			{
        				if(Utils.debug)
        					Log.i(TAG, e.toString());
        			}
        		}
            }
        });
		
		sandboxButton.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
            	Log.i(TAG, "sandbox button");
            	ServerRegistrationActivity.this.isSandbox = true;
            	if (ServerRegistrationActivity.isIntentAvailable(
            			ServerRegistrationActivity.this, "com.google.zxing.client.android.SCAN")) {
        			Intent intent = new Intent("com.google.zxing.client.android.SCAN");
        			try {
        				startActivityForResult(intent, BARCODE_READER);
        			} catch(ActivityNotFoundException e){
        				if(Utils.debug)
        					Log.i(TAG, e.toString());
        			}
        		}
            }
        });
	}

	/**
	 * This method is used to check whether or not the user has an intent
	 * available before an activity is actually started.  This is only 
	 * invoked on the register view to check whether or not the intent for
	 * the barcode scanner is available.  Since the barcode scanner requires
	 * a downloadable dependency, the user will not be allowed to click the 
	 * "Read Barcode" button unless the phone is able to do so.
	 * @param context
	 * @param action
	 * @return
	 */
	public static boolean isIntentAvailable(Context context, String action) {
		final PackageManager packageManager = context.getPackageManager();
		final Intent intent = new Intent(action);
		List<ResolveInfo> list = packageManager.queryIntentActivities(intent, PackageManager.MATCH_DEFAULT_ONLY);
		return list.size() > 0;
	}

	/**
	 * Handles server registration by decoding the JSON Object that the barcode reader gets
	 * from the server site containing the server address and the authentication key.  These
	 * two pieces of information are stored as shared preferences.  The user is then prompted
	 * to choose a project from the server to work on and sync with.
	 */
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		
		if(false);
		
		if (resultCode == RESULT_CANCELED)
			return;
		switch (requestCode) {
		case BARCODE_READER:
			String value = data.getStringExtra("SCAN_RESULT");
			JSONObject object;
			try {
				object = new JSONObject(value);
				String server = object.getString("server");
				String authKey = object.getString("authKey");
				if(Utils.debug)
					Log.i(TAG, "server= "+server+", authKey= "+authKey);
				
				TelephonyManager manager = (TelephonyManager) this.getSystemService(Context.TELEPHONY_SERVICE);
				String imei = manager.getDeviceId();
				
				Communicator communicator = new Communicator(this);
				boolean registered = communicator.registerDevice(server, authKey, imei);
				if (registered == true) {
					SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(this);
					Editor spEditor = sp.edit();
					
					spEditor.putString("SERVER_ADDRESS", server);
					spEditor.putString("AUTHKEY", authKey);
					spEditor.commit();
				}
				SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(this);
				int projectId = sp.getInt("PROJECT_ID", 0);
				if (projectId == 0) {
					Intent intent = new Intent(this, ShowProjectsActivity.class);
					startActivity(intent);
				}
				finish();
				
			} catch (JSONException e) {
				if(Utils.debug)
					Log.e(TAG, e.toString());
			}
			break;
		}
	}
}