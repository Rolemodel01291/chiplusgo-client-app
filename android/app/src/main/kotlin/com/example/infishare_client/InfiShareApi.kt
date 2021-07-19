package com.example.chiplusgo_client

import com.facebook.stetho.okhttp3.StethoInterceptor
import com.google.gson.GsonBuilder
import io.reactivex.Observable
import okhttp3.OkHttpClient
import okhttp3.ResponseBody
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory

class InfiShareApi {
    fun chargeCustomerWithPaymentIntent(token: String,
                       businessId: String ,
                       couponId: String,
                       amount: Int,
                       count: Int,
                       reward: Int,
                       tips: Double,
                       tax: Double,
                       balance: Double=0.0): Observable<ResponseBody> {
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
        return instance.chargeCustomerWithIntent(hashMapOf(
                "Amount" to amount,
                "CouponId" to couponId,
                "Count" to count,
                "Tips" to tips,
                "Tax" to tax,
                "Payer" to hashMapOf("Balance" to balance),
                "Reward" to reward,
                "BusinessId" to businessId
        ))
    }

    fun chargeCustomer(token: String,
                       businessId: String ,
                       couponId: String,
                       amount: Int,
                       count: Int,
                       reward: Int,
                       tips: Double,
                       tax: Double,
                       balance: Double=0.0):Observable<ResponseBody> {
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
        return instance.chargeCustomer(hashMapOf(
                "Amount" to amount,
                "CouponId" to couponId,
                "Count" to count,
                "Tips" to tips,
                "Tax" to tax,
                "Payer" to hashMapOf("Balance" to balance),
                "Reward" to reward,
                "BusinessId" to businessId,
                "SourceId" to ""
        ))
    }

    fun chargeBalanceWith(token: String, amount: Int):Observable<ResponseBody> {
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
        return instance.chargeBalanceWithIntent(hashMapOf(
                "Amount" to amount
        ))
    }
}