package com.example.social_media_share

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class SocialMediaSharePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        val channel = MethodChannel(binding.binaryMessenger, "social_media_share/channel")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val text = call.argument<String>("text")
        val filePath = call.argument<String>("filePath")

        when (call.method) {
            "share_whatsapp" -> {
                shareToWhatsApp(text, filePath)
                result.success(null)
            }
            "share_facebook" -> {
                shareToFacebook(text, filePath)
                result.success(null)
            }
            "share_instagram" -> {
                shareToInstagram(text, filePath)
                result.success(null)
            }
            "share_all" -> {
                shareToAll(text, filePath)
                result.success(null)
            }
            "copy_link" -> {
                copyLink(text)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    // ---------------- WhatsApp Share ----------------
    private fun shareToWhatsApp(text: String?, filePath: String?) {
        val packages = listOf("com.whatsapp", "com.whatsapp.w4b")
        var shared = false

        for (pkg in packages) {
            val intent = Intent(Intent.ACTION_SEND).apply {
                type = if (!filePath.isNullOrEmpty()) {
                    when (File(filePath).extension.lowercase()) {
                        "jpg", "jpeg" -> "image/jpeg"
                        "png" -> "image/png"
                        else -> "*/*"
                    }
                } else "text/plain"

                `package` = pkg
                text?.let { putExtra(Intent.EXTRA_TEXT, it) }

                if (!filePath.isNullOrEmpty() && File(filePath).exists()) {
                    val uri = FileProvider.getUriForFile(
                        context,
                        context.packageName + ".fileprovider",
                        File(filePath)
                    )
                    putExtra(Intent.EXTRA_STREAM, uri)
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }
            }

            if (intent.resolveActivity(context.packageManager) != null) {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(intent)
                shared = true
                break
            }
        }

        if (!shared) {
            val playStoreIntent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=com.whatsapp")
            )
            playStoreIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(playStoreIntent)
        }
    }

    // ---------------- Facebook Share ----------------
    private fun shareToFacebook(text: String?, filePath: String?) {
        val intent = Intent(Intent.ACTION_SEND)
        intent.type = if (!filePath.isNullOrEmpty() && File(filePath).exists()) "image/*" else "text/plain"
        text?.let { intent.putExtra(Intent.EXTRA_TEXT, it) }

        if (!filePath.isNullOrEmpty() && File(filePath).exists()) {
            val uri = FileProvider.getUriForFile(
                context,
                context.packageName + ".fileprovider",
                File(filePath)
            )
            intent.putExtra(Intent.EXTRA_STREAM, uri)
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        intent.setPackage("com.facebook.katana")

        if (intent.resolveActivity(context.packageManager) != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
        } else {
            val fbWebUrl = Uri.parse("https://www.facebook.com/sharer/sharer.php?u=${Uri.encode(text)}")
            val webIntent = Intent(Intent.ACTION_VIEW, fbWebUrl)
            webIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(webIntent)
        }
    }

    // ---------------- Instagram Share ----------------
    private fun shareToInstagram(text: String?, filePath: String?) {
        val hasImage = !filePath.isNullOrEmpty() && File(filePath).exists()

        // Prepare the intent
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = if (hasImage) "image/*" else "text/plain"

            if (hasImage) {
                val file = File(filePath!!)
                val uri = FileProvider.getUriForFile(
                    context,
                    context.packageName + ".fileprovider",
                    file
                )
                putExtra(Intent.EXTRA_STREAM, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }

            // Force Instagram
            setPackage("com.instagram.android")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        // Copy caption to clipboard
        if (!text.isNullOrEmpty()) {
            val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as android.content.ClipboardManager
            val clip = android.content.ClipData.newPlainText("Instagram Caption", text)
            clipboard.setPrimaryClip(clip)

            Toast.makeText(
                context,
                "Caption copied! Paste it in Instagram before posting.",
                Toast.LENGTH_SHORT
            ).show()
        }

        // Check Instagram is installed
        val isInstagramInstalled = try {
            context.packageManager.getPackageInfo("com.instagram.android", 0)
            true
        } catch (e: Exception) {
            false
        }

        if (isInstagramInstalled) {
            try {
                context.startActivity(intent)
            } catch (e: Exception) {
                // fallback if Instagram can't handle the intent
                val chooser = Intent.createChooser(intent, "Share to Instagram")
                chooser.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context.startActivity(chooser)
            }
        } else {
            // Instagram not installed → Play Store
            val playStoreIntent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=com.instagram.android")
            )
            playStoreIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(playStoreIntent)
        }
    }


    // ---------------- All Share ----------------
    private fun shareToAll(text: String?, filePath: String?) {
        val hasImage = !filePath.isNullOrEmpty() && File(filePath).exists()

        val intent = Intent(Intent.ACTION_SEND).apply {
            type = if (hasImage) "image/*" else "text/plain"

            if (hasImage) {
                val file = File(filePath!!)
                val uri = FileProvider.getUriForFile(
                    context,
                    context.packageName + ".fileprovider",
                    file
                )
                putExtra(Intent.EXTRA_STREAM, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }

            // Remove setPackage and use chooser to avoid hijacking the task
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        // Copy caption text to clipboard
        if (!text.isNullOrEmpty()) {
            val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as android.content.ClipboardManager
            val clip = android.content.ClipData.newPlainText("Instagram Caption", text)
            clipboard.setPrimaryClip(clip)

            Toast.makeText(
                context,
                "Caption copied! Paste it in Instagram before posting.",
                Toast.LENGTH_SHORT
            ).show()
        }

        // Check if Instagram is installed
        val isInstagramInstalled = try {
            context.packageManager.getPackageInfo("com.instagram.android", 0)
            true
        } catch (e: Exception) {
            false
        }

        if (isInstagramInstalled) {
            // Use a chooser so Instagram opens but your app can come back after sharing
            val chooser = Intent.createChooser(intent, "Share to Instagram")
            chooser.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(chooser)
        } else {
            // Instagram not installed → open Play Store
            val playStoreIntent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse("https://play.google.com/store/apps/details?id=com.instagram.android")
            )
            playStoreIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(playStoreIntent)
        }
    }


    // ---------------- Copy Link ----------------

    private fun copyLink(text: String?) {
        if (!text.isNullOrEmpty()) {
            val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as android.content.ClipboardManager
            val clip = android.content.ClipData.newPlainText("Instagram Caption", text)
            clipboard.setPrimaryClip(clip)

            Toast.makeText(
                context,
                "Caption copied! Paste it in Instagram before posting.",
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // No cleanup needed
    }
}
