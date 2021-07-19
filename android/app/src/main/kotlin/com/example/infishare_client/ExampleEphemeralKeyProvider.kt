package com.example.chiplusgo_client

import android.util.Log
import androidx.annotation.Size
import com.facebook.stetho.okhttp3.StethoInterceptor
import com.google.gson.GsonBuilder
import com.stripe.android.EphemeralKeyProvider
import com.stripe.android.EphemeralKeyUpdateListener
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import java.io.IOException

class EphemeralKeyProvider(val token: String) : EphemeralKeyProvider {

    private val compositeDisposable: CompositeDisposable = CompositeDisposable()

    override fun createEphemeralKey(
            @Size(min = 4) apiVersion: String,
            keyUpdateListener: EphemeralKeyUpdateListener
    ) {
        Log.e("Ephemeralkey","called")
        val logging = HttpLoggingInterceptor()
                .setLevel(HttpLoggingInterceptor.Level.BODY)
        val httpClient = OkHttpClient.Builder().addInterceptor { chain ->
            val original = chain.request()

            // Request customization: add request headers
            val requestBuilder = original.newBuilder()
                    .header("Authorization", "Bearer $token") // <-- this is the important line

            val request = requestBuilder.build()
            chain.proceed(request)
        }
                .addInterceptor(logging)
                .addNetworkInterceptor(StethoInterceptor())
                .build()

        val gson = GsonBuilder()
                .setLenient()
                .create()

        val instance = Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create(gson))
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .baseUrl("https://us-central1-chiplusgo-95ec4.cloudfunctions.net/")
                .client(httpClient)
                .build().create(BackendApi::class.java)

        compositeDisposable.add(
                instance.createEphemeralKey(hashMapOf("api_version" to apiVersion))
                        .subscribeOn(Schedulers.io())
                        .observeOn(AndroidSchedulers.mainThread())
                        .subscribe ({ responseBody ->
                            try {
                                val ephemeralKeyJson = responseBody.string()
                                keyUpdateListener.onKeyUpdate(ephemeralKeyJson)
                            } catch (e: IOException) {
                                keyUpdateListener
                                        .onKeyUpdateFailure(0, e.message ?: "")
                            }
                        },{
                            keyUpdateListener.onKeyUpdateFailure(0, it.message ?:"Server error")
                        }))
    }
}