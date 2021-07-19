package com.example.chiplusgo_client

import io.reactivex.Observable
import okhttp3.ResponseBody
import retrofit2.http.Body
import retrofit2.http.FieldMap
import retrofit2.http.FormUrlEncoded
import retrofit2.http.POST

/**
 * A Retrofit service used to communicate with a server.
 */
interface BackendApi {

    @FormUrlEncoded
    @POST("ephemeralKeys/")
    fun createEphemeralKey(@FieldMap apiVersionMap: HashMap<String, String>): Observable<ResponseBody>

    @POST("paymentIntentV2/chargeCust/")
    fun chargeCustomerWithIntent(@Body paymentDataMap: HashMap<String, Any>): Observable<ResponseBody>

    @POST("paymentIntentV2/recharge/")
    fun chargeBalanceWithIntent(@Body paymentDataMap: HashMap<String, Any>): Observable<ResponseBody>

    @POST("chargeBalanceWith/")
    fun chargeBalanceWith(@Body paymentDataMap: HashMap<String, Any>): Observable<ResponseBody>

    @POST("chargeCust/")
    fun chargeCustomer(@Body paymentDataMap: HashMap<String, Any>): Observable<ResponseBody>
}