package dev.yanshouwang.bluetooth_low_energy

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi

class PendingIntentApi(private val context: Context, private val instanceManager: InstanceManager) : PendingIntentHostApi {
    override fun getService(requestCode: Long, intentHashCode: Long, flags: Long): Long {
        val requestCode1 = requestCode.toInt()
        val intent = instanceManager.valueOf(intentHashCode) as Intent
        val flags1 = flags.toInt()
        val pendingIntent = PendingIntent.getService(context, requestCode1, intent, flags1)
        return instanceManager.allocate(pendingIntent)
    }

    override fun getActivities(requestCode: Long, intentHashCodes: List<Long>, flags: Long): Long {
        val requestCode1 = requestCode.toInt()
        val intents = intentHashCodes.map { hashCode -> instanceManager.valueOf(hashCode) as Intent }.toTypedArray()
        val flags1 = flags.toInt()
        val pendingIntent = PendingIntent.getActivities(context, requestCode1, intents, flags1)
        return instanceManager.allocate(pendingIntent)
    }

    override fun getActivities1(requestCode: Long, intentHashCodes: List<Long>, flags: Long, optionsHashCode: Long?): Long {
        val requestCode1 = requestCode.toInt()
        val intents = intentHashCodes.map { hashCode -> instanceManager.valueOf(hashCode) as Intent }.toTypedArray()
        val flags1 = flags.toInt()
        val options = if (optionsHashCode == null) null
        else instanceManager.valueOf(optionsHashCode) as Bundle
        val pendingIntent = PendingIntent.getActivities(context, requestCode1, intents, flags1, options)
        return instanceManager.allocate(pendingIntent)
    }

    override fun getActivity(requestCode: Long, intentHashCode: Long, flags: Long): Long {
        val requestCode1 = requestCode.toInt()
        val intent = instanceManager.valueOf(intentHashCode) as Intent
        val flags1 = flags.toInt()
        val pendingIntent = PendingIntent.getActivity(context, requestCode1, intent, flags1)
        return instanceManager.allocate(pendingIntent)
    }

    override fun getActivity1(requestCode: Long, intentHashCode: Long, flags: Long, optionsHashCode: Long?): Long {
        val requestCode1 = requestCode.toInt()
        val intent = instanceManager.valueOf(intentHashCode) as Intent
        val flags1 = flags.toInt()
        val options = if (optionsHashCode == null) null
        else instanceManager.valueOf(optionsHashCode) as Bundle
        val pendingIntent = PendingIntent.getActivity(context, requestCode1, intent, flags1, options)
        return instanceManager.allocate(pendingIntent)
    }

    override fun getBroadcast(requestCode: Long, intentHashCode: Long, flags: Long): Long {
        val requestCode1 = requestCode.toInt()
        val intent = instanceManager.valueOf(intentHashCode) as Intent
        val flags1 = flags.toInt()
        val pendingIntent = PendingIntent.getBroadcast(context, requestCode1, intent, flags1)
        return instanceManager.allocate(pendingIntent)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun getForegroundService(requestCode: Long, intentHashCode: Long, flags: Long): Long {
        val requestCode1 = requestCode.toInt()
        val intent = instanceManager.valueOf(intentHashCode) as Intent
        val flags1 = flags.toInt()
        val pendingIntent = PendingIntent.getForegroundService(context, requestCode1, intent, flags1)
        return instanceManager.allocate(pendingIntent)
    }
}