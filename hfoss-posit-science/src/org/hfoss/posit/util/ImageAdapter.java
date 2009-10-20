package org.hfoss.posit.util;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CursorAdapter;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.LinearLayout.LayoutParams;

public class ImageAdapter extends CursorAdapter
{

    private Context mContext;
    
   
	
    public ImageAdapter(Cursor c, Context context)
    {
        super(c, context);
        mContext = context;
    }
    
    @Override
    public void bindView(View view, Context context, Cursor cursor)
    {
    	Log.i("BIND", cursor.getString(2));
    	Log.e("BIND", cursor.getString(0));
    	Bitmap bp = BitmapFactory
                .decodeFile(cursor.getString(1));
        
        ImageView i = (ImageView) view;
        i.setImageBitmap(bp);
        i.setAdjustViewBounds(true);
        i.setLayoutParams(new Gallery.LayoutParams(
                LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
        i.setBackground(android.R.drawable.picture_frame);

    }

    @Override
    public View newView(Context context, Cursor cursor, ViewGroup parent)
    {
        return new ImageView(mContext);
    }

    public float getAlpha(boolean focused, int offset)
    {
        return Math.max(0.2f, 1.0f - (0.2f * Math.abs(offset)));
    }

    public float getScale(boolean focused, int offset)
    {
        return Math.max(0, offset == 0 ? 1.0f : 0.6f);
    }
    
    
}
