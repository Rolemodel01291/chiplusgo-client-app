package com.example.chiplusgo_client

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.stripe.android.*
import com.stripe.android.model.ConfirmPaymentIntentParams
import com.stripe.android.model.Customer
import com.stripe.android.model.StripeIntent
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import org.json.JSONObject

class MainActivity: FlutterActivity(), EventChannel.StreamHandler, PaymentSession.PaymentSessionListener {


  override fun onCommunicatingStateChanged(isCommunicating: Boolean) {
    Log.e("stripe","isCommunicate $isCommunicating")
  }

  override fun onError(errorCode: Int, errorMessage: String) {
    if (eventSink != null) {
      eventSink!!.success(hashMapOf("error" to "Fail to load payment method"))
    }
  }

  override fun onPaymentSessionDataChanged(data: PaymentSessionData) {
    if (eventSink != null) {
      if (paymentSession?.paymentSessionData?.paymentMethod != null) {
        Log.e("stripe", paymentSession!!.paymentSessionData.paymentMethod!!.card!!.toString())
        Log.e("stripe","isCommunicate"+paymentSession!!.paymentSessionData.paymentMethod!!.card!!.brand!!)
        val paymentMethod = paymentSession!!.paymentSessionData.paymentMethod!!.card!!.brand!!
        val cardNum = paymentSession!!.paymentSessionData.paymentMethod!!.card!!.last4!!
        eventSink!!.success(hashMapOf("method" to "$paymentMethod $cardNum"))
        Log.e("stripe","isCommunicate $paymentMethod $cardNum")
      } else {
        eventSink!!.success(hashMapOf("method" to ""))
      }
    }
  }

  override fun onCancel(p0: Any?) {
    eventSink = null
  }

  override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
    Log.e("event sink","on listener")
    val paras = p0 as HashMap<String, Any>
    PaymentConfiguration.init(this,"pk_test_51IhGpXFIj1dtK6GQYgumpbwCzaH5fRBG4aWLDZLbBgu5qK1gHJ4ihRBa0TyaKGrQ5abVX31iXSxdxCRjybg1In9U008kFVC82F")
    CustomerSession.initCustomerSession(this, EphemeralKeyProvider(paras["token"] as String))
    eventSink = p1

    createPaymentSession()
  }

  private fun createPaymentSession() {
    paymentSession = PaymentSession(this)
    paymentSession!!.init(
            this,
            PaymentSessionConfig.Builder()
                    .setShippingInfoRequired(false)
                    .build()
    )
  }

  private var paymentSession: PaymentSession? = null
  private var checkoutResult: MethodChannel.Result? = null
  private var eventSink: EventChannel.EventSink? = null
  private val compositeSubscription = CompositeDisposable()
  private var paymentMap: HashMap<String, Any> = HashMap()
  private var stripe: Stripe? = null
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, "com.infishare/stripe_payment").setMethodCallHandler{ call, result ->
      Log.e("Stripe","init")
      stripe = Stripe(
              applicationContext,
              "pk_test_51IhGpXFIj1dtK6GQYgumpbwCzaH5fRBG4aWLDZLbBgu5qK1gHJ4ihRBa0TyaKGrQ5abVX31iXSxdxCRjybg1In9U008kFVC82F")
      if (call.method == "editPayment") {
        val paras = call.arguments as HashMap<String, Any>
        PaymentConfiguration.init(this,"pk_test_51IhGpXFIj1dtK6GQYgumpbwCzaH5fRBG4aWLDZLbBgu5qK1gHJ4ihRBa0TyaKGrQ5abVX31iXSxdxCRjybg1In9U008kFVC82F")
        CustomerSession.initCustomerSession(this, EphemeralKeyProvider(paras["token"] as String))
        createPaymentSession()
        paymentSession?.presentPaymentMethodSelection()
        result.success(hashMapOf("msg" to "success"))
      } else if (call.method == "showChoosePayment") {
        paymentSession?.presentPaymentMethodSelection()
      } else if (call.method == "createPaymentToken") {
        checkoutResult = result
        val map = call.arguments as HashMap<String, Any>
        paymentMap = map
        val amount = map["amount"] as Int
        if (amount == 0) {
          compositeSubscription.add(InfiShareApi().chargeCustomerWithPaymentIntent(
                  token = paymentMap["token"] as String,
                  businessId = paymentMap["businessId"] as String,
                  couponId = paymentMap["couponId"] as String,
                  amount = paymentMap["amount"] as Int,
                  count = paymentMap["count"] as Int,
                  reward = paymentMap["reward"] as Int,
                  tips = paymentMap["tips"] as Double,
                  tax = paymentMap["tax"] as Double,
                  balance = paymentMap["balance"] as Double)
                  .subscribeOn(Schedulers.io())
                  .observeOn(AndroidSchedulers.mainThread())
                  .subscribe(
                  {
                    val response = JSONObject(it.string())
                    if(response.getString("receipt_number") != null) {
                      checkoutResult?.success(hashMapOf("receipt" to response.get("receipt_number")))
                    } else {
                      checkoutResult?.success(hashMapOf("error" to response.getString("message")))
                    }
                  },
                  {
                    checkoutResult?.success(hashMapOf("error" to it.toString()))
                    Log.e("error", it.toString())
                  }
          ))
        } else {
          Log.e("stripe", "get payment init")
          compositeSubscription.add(InfiShareApi().chargeCustomerWithPaymentIntent(
                  token = paymentMap["token"] as String,
                  businessId = paymentMap["businessId"] as String,
                  couponId = paymentMap["couponId"] as String,
                  amount = paymentMap["amount"] as Int,
                  count = paymentMap["count"] as Int,
                  reward = paymentMap["reward"] as Int,
                  tips = paymentMap["tips"] as Double,
                  tax = paymentMap["tax"] as Double,
                  balance = paymentMap["balance"] as Double
          ).subscribeOn(Schedulers.io())
                  .observeOn(AndroidSchedulers.mainThread())
                  .subscribe(
                          {
                            val response = JSONObject(it.string())
                            if (response.getString("Client_secret") != null) {
                              Log.e("Client_secret", response.getString("Client_secret"))
                              stripe?.confirmPayment(this, ConfirmPaymentIntentParams.createWithPaymentMethodId(
                                      paymentSession!!.paymentSessionData.paymentMethod!!.id!!,
                                      response.getString("Client_secret"),
                                      ""
                              ))
                            } else {
                              checkoutResult?.success(hashMapOf("error" to response.getString("message")))
                            }
                          },
                          {
                            Log.e("error", it.message)
                            checkoutResult?.success(hashMapOf("error" to it.toString()))
                          }
                  ))
        }
      } else if (call.method == "chargeInfiCash") {
        Log.e("strip","charge inficash")
        checkoutResult = result
        val map = call.arguments as HashMap<String, Any>
        paymentMap = map
        this.paymentSession?.setCartTotal((map["amount"] as Int).toLong())
        compositeSubscription.add(InfiShareApi().chargeBalanceWith(
                token = paymentMap["token"] as String,
                amount = paymentMap["amount"] as Int
        ).doOnError { error -> checkoutResult?.success(hashMapOf("error" to error.toString()))}
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(
                        {
                          val response = JSONObject(it.string())
                          if (response.getString("Client_secret") != null) {
                            Log.e("Client_secret", response.getString("Client_secret"))
                            stripe?.confirmPayment(this, ConfirmPaymentIntentParams.createWithPaymentMethodId(
                                    paymentSession!!.paymentSessionData.paymentMethod!!.id!!,
                                    response.getString("Client_secret"),
                                    ""
                            ))
                          } else {
                            checkoutResult?.success(hashMapOf("error" to response.getString("message")))
                          }
                        },
                        {
                          Log.e("error",it.message)
                          checkoutResult?.success(hashMapOf("error" to it.message))
                        }
                ))
      }
    }

    val paymentChannel = EventChannel(flutterView, "com.infishare/stripe_payment_method")
    paymentChannel.setStreamHandler(this)
  }

  private fun processStripeIntent(stripeIntent: StripeIntent) {
    if (stripeIntent.requiresAction()) {
      stripe?.authenticatePayment(this, stripeIntent.clientSecret!!)
    } else if (stripeIntent.requiresConfirmation()) {
      checkoutResult?.success(hashMapOf("error" to "Unable to auth payment"))
      //confirmStripeIntent(stripeIntent.id!!, Settings.STRIPE_ACCOUNT_ID)
    } else if (stripeIntent.status == StripeIntent.Status.Succeeded) {
      checkoutResult?.success(hashMapOf("receipt" to stripeIntent.id!!.substring(3, endIndex = 12)))
    } else if (stripeIntent.status == StripeIntent.Status.RequiresPaymentMethod) {
      // reset payment method and shipping if authentication fails
      checkoutResult?.success(hashMapOf("error" to "Unable to auth payment"))
      createPaymentSession()
      Log.e("stripe","StripeIntent.Status.RequiresPaymentMethod")
    } else {
      checkoutResult?.success(hashMapOf("error" to "Unable to finish payment"))
      Log.e("stripe","Unknow intent")
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    if (stripe != null) {
      val isPaymentIntentResult = stripe!!.onPaymentResult(
              requestCode, data,
              object : ApiResultCallback<PaymentIntentResult> {
                override fun onSuccess(result: PaymentIntentResult) {
                  processStripeIntent(result.intent)
                }

                override fun onError(e: Exception) {
                  checkoutResult?.success(hashMapOf("error" to e.message))
                  Log.e("error",e.message)
                }
              })

      if (!isPaymentIntentResult) {
        val isSetupIntentResult = stripe!!.onSetupResult(requestCode, data,
                object : ApiResultCallback<SetupIntentResult> {
                  override fun onSuccess(result: SetupIntentResult) {
                    processStripeIntent(result.intent)
                  }

                  override fun onError(e: Exception) {
                    checkoutResult?.success(hashMapOf("error" to e.message))
                    Log.e("error",e.message)
                  }
                })
        if (!isSetupIntentResult) {
          if (data != null) {
            paymentSession?.handlePaymentData(requestCode, resultCode, data)
          } else {
            paymentSession?.handlePaymentData(requestCode, resultCode, Intent())
          }

        }
      }
    }
  }

  override fun onDestroy() {
    compositeSubscription.dispose()
    paymentSession?.onDestroy()
    super.onDestroy()
  }
}


