package dev.yanshouwang.bluetooth_low_energy

import android.content.ClipData
import android.content.ComponentName
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Rect
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Parcel
import android.os.Parcelable
import androidx.annotation.RequiresApi
import java.io.Serializable

class IntentApi(private val context: Context, private val instanceManager: InstanceManager) : IntentHostApi {
    override fun getAction(hashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.action
    }

    override fun setAction(hashCode: Long, action: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.setAction(action)
        return instanceManager.allocate(intent1)
    }

    override fun getData(hashCode: Long): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val data = intent.data ?: return null
        return instanceManager.allocate(data)
    }

    override fun setData(hashCode: Long, dataHashCode: Long?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val data = if (dataHashCode == null) null
        else instanceManager.valueOf(dataHashCode) as Uri
        val intent1 = intent.setData(data)
        return instanceManager.allocate(intent1)
    }

    override fun getPackage(hashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.`package`
    }

    override fun setPackage(hashCode: Long, packageName: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.setPackage(packageName)
        return instanceManager.allocate(intent1)
    }

    override fun getCategories(hashCode: Long): List<String> {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.categories.toList()
    }

    override fun getClipData(hashCode: Long): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val clipData = intent.clipData
        return if (clipData == null) null
        else instanceManager.allocate(clipData)
    }

    override fun setClipData(hashCode: Long, clipDataHashCode: Long?) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val clipData = if (clipDataHashCode == null) null
        else instanceManager.valueOf(clipDataHashCode) as ClipData
        intent.clipData = clipData
    }

    override fun getComponent(hashCode: Long): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val component = intent.component
        return if (component == null) null
        else instanceManager.allocate(component)
    }

    override fun setComponent(hashCode: Long, componentHashCode: Long?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val component = if (componentHashCode == null) null
        else instanceManager.valueOf(componentHashCode) as ComponentName
        val intent1 = intent.setComponent(component)
        return instanceManager.allocate(intent1)
    }

    override fun getDataString(hashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.dataString
    }

    override fun getExtras(hashCode: Long): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val extras = intent.extras
        return if (extras == null) null
        else instanceManager.allocate(extras)
    }

    override fun getFlags(hashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.flags.toLong()
    }

    override fun setFlags(hashCode: Long, flags: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val flags1 = flags.toInt()
        val intent1 = intent.setFlags(flags1)
        return instanceManager.allocate(intent1)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun getIdentifier(hashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.identifier
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun setIdentifier(hashCode: Long, identifier: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.setIdentifier(identifier)
        return instanceManager.allocate(intent1)
    }

    override fun getScheme(hashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.scheme
    }

    override fun getSelector(hashCode: Long): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val selector = intent.selector
        return if (selector == null) null
        else instanceManager.allocate(selector)
    }

    override fun setSelector(hashCode: Long, selectorHashCode: Long?) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val selector = if (selectorHashCode == null) null
        else instanceManager.valueOf(selectorHashCode) as Intent
        intent.selector = selector
    }

    override fun getSourceBounds(hashCode: Long): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val sourceBounds = intent.sourceBounds
        return if (sourceBounds == null) null
        else instanceManager.allocate(sourceBounds)
    }

    override fun setSourceBounds(hashCode: Long, sourceBoundsHashCode: Long?) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val sourceBounds = if (sourceBoundsHashCode == null) null
        else instanceManager.valueOf(sourceBoundsHashCode) as Rect
        intent.sourceBounds = sourceBounds
    }

    override fun getType(hashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.type
    }

    override fun setType(hashCode: Long, type: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.setType(type)
        return instanceManager.allocate(intent1)
    }

    override fun addCategory(hashCode: Long, category: String): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.addCategory(category)
        return instanceManager.allocate(intent1)
    }

    override fun addFlags(hashCode: Long, flags: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val flags1 = flags.toInt()
        val intent1 = intent.addFlags(flags1)
        return instanceManager.allocate(intent1)
    }

    override fun cloneFilter(hashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.cloneFilter()
        return instanceManager.allocate(intent1)
    }

    override fun fillIn(hashCode: Long, otherHashCode: Long, flags: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val other = instanceManager.valueOf(otherHashCode) as Intent
        val flags1 = flags.toInt()
        return intent.fillIn(other, flags1).toLong()
    }

    override fun filterEquals(hashCode: Long, otherHashCode: Long): Boolean {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val others = instanceManager.valueOf(otherHashCode) as Intent
        return intent.filterEquals(others)
    }

    override fun filterHashCode(hashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.filterHashCode().toLong()
    }

    override fun getBooleanArrayExtra(hashCode: Long, name: String): List<Boolean>? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getBooleanArrayExtra(name)?.toList()
    }

    override fun putBooleanArrayExtra(hashCode: Long, name: String, value: List<Boolean>?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = value?.toBooleanArray()
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getBooleanExtra(hashCode: Long, name: String, defaultValue: Boolean): Boolean {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getBooleanExtra(name, defaultValue)
    }

    override fun putBooleanExtra(hashCode: Long, name: String, value: Boolean): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.putExtra(name, value)
        return instanceManager.allocate(intent1)
    }

    override fun getBundleExtra(hashCode: Long, name: String): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val bundle = intent.getBundleExtra(name)
        return if (bundle == null) null
        else instanceManager.allocate(bundle)
    }

    override fun putBundleExtra(hashCode: Long, name: String, valueHashCode: Long?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = if (valueHashCode == null) null
        else instanceManager.valueOf(valueHashCode) as Bundle
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getByteArrayExtra(hashCode: Long, name: String): ByteArray? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getByteArrayExtra(name)
    }

    override fun putByteArrayExtra(hashCode: Long, name: String, value: ByteArray?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.putExtra(name, value)
        return instanceManager.allocate(intent1)
    }

    override fun getDoubleArrayExtra(hashCode: Long, name: String): List<Double>? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getDoubleArrayExtra(name)?.toList()
    }

    override fun putDoubleArrayExtra(hashCode: Long, name: String, value: List<Double>?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = value?.toDoubleArray()
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getDoubleExtra(hashCode: Long, name: String, defaultValue: Double): Double {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getDoubleExtra(name, defaultValue)
    }

    override fun putDoubleExtra(hashCode: Long, name: String, value: Double): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.putExtra(name, value)
        return instanceManager.allocate(intent1)
    }

    override fun getIntArrayExtra(hashCode: Long, name: String): List<Long>? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getIntArrayExtra(name)?.map { item -> item.toLong() }
    }

    override fun putIntArrayExtra(hashCode: Long, name: String, value: List<Long>?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = value?.map { i -> i.toInt() }?.toIntArray()
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getIntExtra(hashCode: Long, name: String, defaultValue: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val defaultValue1 = defaultValue.toInt()
        return intent.getIntExtra(name, defaultValue1).toLong()
    }

    override fun putIntExtra(hashCode: Long, name: String, value: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = value.toInt()
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getLongArrayExtra(hashCode: Long, name: String): List<Long>? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getLongArrayExtra(name)?.toList()
    }

    override fun putLongArrayExtra(hashCode: Long, name: String, value: List<Long>?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = value?.toLongArray()
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getLongExtra(hashCode: Long, name: String, defaultValue: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getLongExtra(name, defaultValue)
    }

    override fun putLongExtra(hashCode: Long, name: String, value: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.putExtra(name, value)
        return instanceManager.allocate(intent1)
    }

    override fun getParcelableArrayExtra(hashCode: Long, name: String): List<Long>? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getParcelableArrayExtra(name)?.map { parcelable -> instanceManager.allocate(parcelable) }
    }

    override fun putParcelableArrayExtra(hashCode: Long, name: String, valueHashCode: List<Long>?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = valueHashCode?.map { parcelableHashCode -> instanceManager.valueOf(parcelableHashCode) as Parcelable }?.toTypedArray()
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getParcelableExtra(hashCode: Long, name: String): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val parcelable = intent.getParcelableExtra<Parcelable>(name)
        return if (parcelable == null) null
        else instanceManager.allocate(parcelable)
    }

    override fun putParcelableExtra(hashCode: Long, name: String, valueHashCode: Long?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = if (valueHashCode == null) null
        else instanceManager.valueOf(valueHashCode) as Parcelable
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getSerializableExtra(hashCode: Long, name: String): Long? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val serializable = intent.getSerializableExtra(name)
        return if (serializable == null) null
        else instanceManager.allocate(serializable)
    }

    override fun putSerializableExtra(hashCode: Long, name: String, valueHashCode: Long?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value = if (valueHashCode == null) null
        else instanceManager.valueOf(valueHashCode) as Serializable
        val intent1 = intent.putExtra(name, value)
        return instanceManager.allocate(intent1)
    }

    override fun getStringArrayExtra(hashCode: Long, name: String): List<String>? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getStringArrayExtra(name)?.toList()
    }

    override fun putStringArrayExtra(hashCode: Long, name: String, value: List<String>?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val value1 = value?.toTypedArray()
        val intent1 = intent.putExtra(name, value1)
        return instanceManager.allocate(intent1)
    }

    override fun getStringExtra(hashCode: Long, name: String): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.getStringExtra(name)
    }

    override fun putStringExtra(hashCode: Long, name: String, value: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.putExtra(name, value)
        return instanceManager.allocate(intent1)
    }

    override fun putExtras(hashCode: Long, srcHashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val src = instanceManager.valueOf(srcHashCode) as Intent
        val intent1 = intent.putExtras(src)
        return instanceManager.allocate(intent1)
    }

    override fun putExtras1(hashCode: Long, extrasHashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val extras = instanceManager.valueOf(extrasHashCode) as Bundle
        val intent1 = intent.putExtras(extras)
        return instanceManager.allocate(intent1)
    }

    override fun hasCategory(hashCode: Long, category: String): Boolean {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.hasCategory(category)
    }

    override fun hasExtra(hashCode: Long, name: String): Boolean {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.hasExtra(name)
    }

    override fun hasFileDescriptors(hashCode: Long): Boolean {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.hasFileDescriptors()
    }

    override fun readFromParcel(hashCode: Long, inHashCode: Long) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val `in` = instanceManager.valueOf(inHashCode) as Parcel
        intent.readFromParcel(`in`)
    }

    override fun removeCategory(hashCode: Long, category: String) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        intent.removeCategory(category)
    }

    override fun removeExtra(hashCode: Long, name: String) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        intent.removeExtra(name)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun removeFlags(hashCode: Long, flags: Long) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val flags1 = flags.toInt()
        intent.removeFlags(flags1)
    }

    override fun replaceExtras(hashCode: Long, srcHashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val src = instanceManager.valueOf(srcHashCode) as Intent
        val intent1 = intent.replaceExtras(src)
        return instanceManager.allocate(intent1)
    }

    override fun replaceExtras1(hashCode: Long, extrasHashCode: Long?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val extras = if (extrasHashCode == null) null
        else instanceManager.valueOf(extrasHashCode) as Bundle
        val intent1 = intent.replaceExtras(extras)
        return instanceManager.allocate(intent1)
    }

    override fun resolveActivity(hashCode: Long, pmHashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val pm = instanceManager.valueOf(pmHashCode) as PackageManager
        val name = intent.resolveActivity(pm)
        return instanceManager.allocate(name)
    }

    override fun resolveActivityInfo(hashCode: Long, pmHashCode: Long, flags: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val pm = instanceManager.valueOf(pmHashCode) as PackageManager
        val flags1 = flags.toInt()
        val info = intent.resolveActivityInfo(pm, flags1)
        return instanceManager.allocate(info)
    }

    override fun resolveType(hashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        return intent.resolveType(context)
    }

    override fun resolveType1(hashCode: Long, resolverHashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val resolver = instanceManager.valueOf(resolverHashCode) as ContentResolver
        return intent.resolveType(resolver)
    }

    override fun resolveTypeIfNeeded(hashCode: Long, resolverHashCode: Long): String? {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val resolver = instanceManager.valueOf(resolverHashCode) as ContentResolver
        return intent.resolveTypeIfNeeded(resolver)
    }

    override fun setClass(hashCode: Long, clsHashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val cls = instanceManager.valueOf(clsHashCode) as Class<*>
        val intent1 = intent.setClass(context, cls)
        return instanceManager.allocate(intent1)
    }

    override fun setClassName(hashCode: Long, packageName: String, className: String): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.setClassName(packageName, className)
        return instanceManager.allocate(intent1)
    }

    override fun setClassName1(hashCode: Long, className: String): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.setClassName(context, className)
        return instanceManager.allocate(intent1)
    }

    override fun setDataAndNormalize(hashCode: Long, dataHashCode: Long): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val data = instanceManager.valueOf(dataHashCode) as Uri
        val intent1 = intent.setDataAndNormalize(data)
        return instanceManager.allocate(intent1)
    }

    override fun setDataAndType(hashCode: Long, dataHashCode: Long?, type: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val data = if (dataHashCode == null) null
        else instanceManager.valueOf(dataHashCode) as Uri
        val intent1 = intent.setDataAndType(data, type)
        return instanceManager.allocate(intent1)
    }

    override fun setDataAndTypeAndNormalize(hashCode: Long, dataHashCode: Long, type: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val data = instanceManager.valueOf(dataHashCode) as Uri
        val intent1 = intent.setDataAndTypeAndNormalize(data, type)
        return instanceManager.allocate(intent1)
    }

    override fun setExtrasClassLoader(hashCode: Long, loaderHashCode: Long?) {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val loader = if (loaderHashCode == null) null
        else instanceManager.valueOf(loaderHashCode) as ClassLoader
        intent.setExtrasClassLoader(loader)
    }

    override fun setTypeAndNormalize(hashCode: Long, type: String?): Long {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val intent1 = intent.setTypeAndNormalize(type)
        return instanceManager.allocate(intent1)
    }

    override fun toUri(hashCode: Long, flags: Long): String {
        val intent = instanceManager.valueOf(hashCode) as Intent
        val flags1 = flags.toInt()
        return intent.toUri(flags1)
    }
}