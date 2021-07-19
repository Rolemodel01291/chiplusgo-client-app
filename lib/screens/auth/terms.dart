import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infishare_client/blocs/auth_bloc/bloc.dart';
import 'package:infishare_client/language/app_localization.dart';
import 'package:infishare_client/screens/commen_widgets/custom_button.dart';

class TermsScreen extends StatefulWidget {
  TermsScreen();
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  // final GlobalKey<FormFieldState> _key = GlobalKey();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  AuthBloc _authBloc;

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                            child: Text(
                          AppLocalizations.of(context)
                              .translate('TERMS OF SERVICE'),
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        )),
                        SizedBox(
                          height: 30,
                        ),
                        Center(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate('Terms_one'),
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center)),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                            AppLocalizations.of(context).translate('Terms_two'),
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
