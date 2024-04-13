import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hans/action/user_action.dart';
import 'package:hans/model/user.dart';
import 'package:hans/service/state_service.dart';
import 'package:hans/widget/loading_widget.dart';
import 'package:hans/widget/form_item_title.dart';
import 'package:hans/widget/server_status.dart';
import 'package:tekflat_design/tekflat_design.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginSection extends StatefulWidget {
  final Function setUser;
  final Function(AppState appState) setAppState;
  const LoginSection(
      {super.key, required this.setUser, required this.setAppState});

  @override
  State<LoginSection> createState() => _LoginSection();
}

class _LoginSection extends State<LoginSection> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool _loading = false;
  bool _isLogin = true;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _confirmPass2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput
        .invokeMethod('TextInput.setClientFeatures', <String, dynamic>{
      'setAuthenticationConfiguration': true,
      'setAutofillHints': <String>[
        AutofillHints.username,
        AutofillHints.password,
      ],
    });
  }

  @override
  void dispose() {
    SystemChannels.textInput.invokeMethod('TextInput.clearClientFeatures');

    super.dispose();
  }

  void _switch() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submitLogin() async {
    if (_formKey.currentState!.saveAndValidate()) {
      var login = _formKey.currentState!.value['username'];
      var password = _formKey.currentState!.value['password'];
      TekToast.info(msg: "Login in progress $login");
      setState(() {
        _loading = true;
      });
      try {
        User? user;
        user = await UserAction.loginExec(login, password);
        widget.setUser(user);
        if (user != null && user.id != 0) {
          TekToast.success(msg: 'Login success ${user.id}');
          widget.setAppState(AppState.retrieveWallet);
        } else {
          TekToast.error(msg: 'Login failed');
        }
      } on Exception catch (e) {
        TekToast.error(msg: 'Login error $e');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _submitRegister() async {
    if (_formKey.currentState!.saveAndValidate()) {
      var login = _formKey.currentState!.value['username'];
      var password = _formKey.currentState!.value['password'];
      TekToast.info(msg: "Register in progress $login $password");
      setState(() {
        _loading = true;
      });
      try {
        var user = await UserAction.registerExec(login, password);
        TekToast.success(msg: 'Register success ${user.id}');
        widget.setUser(user);
        widget.setAppState(AppState.retrieveWallet);
      } on Exception catch (e) {
        TekToast.error(msg: 'Register error $e');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingWidget();
    return SingleChildScrollView(
        child: Center(
        child: SizedBox(
          width: 350,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TekVSpace.mainSpace,
                const Align(alignment: Alignment.topRight, child: ServerStatus()),
                TekVSpace.mainSpace,
                TekVSpace.p32,
                TekVSpace.p32,
                TekTypography(
                    text: _isLogin ? "Login form" : "Register from",
                    type: TekTypographyType.titleLarge,
                    //color: const Color.fromRGBO(255, 255, 255, 0.9),
                  ),
                TekVSpace.mainSpace,
                FormItemTitleWidget(
                  title: 'Username',
                  isRequired: true,
                  child: TekInput(
                    key: const Key('username'),
                    name: 'username',
                    controller: _username,
                    prefixIcon: const Icon(Icons.person),
                    cursorColor: const Color.fromRGBO(255, 255, 255, 0.9),
                    validator: FormBuilderValidators.required(
                      errorText: 'Username is required',
                    ),
                    // textStyle: const TextStyle(
                    //   color: Color.fromRGBO(255, 255, 255, 0.9),
                    // ),
                  ),
                ),
                TekVSpace.mainSpace,
                FormItemTitleWidget(
                  title: 'Password',
                  isRequired: true,
                  child: TekInputPassword(
                    key: const Key('password'),
                    name: 'password',
                    controller: _confirmPass,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIconShow: Icons.visibility,
                    suffixIconHide: Icons.visibility_off,
                    //cursorColor: Color.fromRGBO(255, 255, 255, 0.9),
                    validator: FormBuilderValidators.required(
                      errorText: 'Password is required',
                    ),
                    // textStyle: const TextStyle(
                    //   color: Color.fromRGBO(255, 255, 255, 0.9),
                    // ),
                    //iconPasswordColor: Color.fromRGBO(255, 255, 255, 0.8),
                  ),
                ),
                if (!_isLogin)
                  FormItemTitleWidget(
                    title: 'Retype Password',
                    isRequired: true,
                    child: TekInputPassword(
                      key: const Key('password2'),
                      name: 'password2',
                      controller: _confirmPass2,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIconShow: Icons.visibility,
                      suffixIconHide: Icons.visibility_off,
                      // cursorColor: const Color.fromRGBO(255, 255, 255, 0.9),
                      validator: FormBuilderValidators.equal(
                        _confirmPass.value.text,
                        errorText:
                            'Password must match with ${_confirmPass.value.text}',
                      ),
                      // textStyle: const TextStyle(
                      //   color: Color.fromRGBO(255, 255, 255, 0.9),
                      // ),
                      //iconPasswordColor: Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                  ),
                TekVSpace.p18,
                TekButton(
                  key: _isLogin
                      ? const Key('loginButton')
                      : const Key('registerButton'),
                  text: _isLogin ? 'Login' : 'Register',
                  width: double.infinity,
                  type: TekButtonType.primary,
                  onPressed: _isLogin ? _submitLogin : _submitRegister,
                ),
                TekVSpace.p18,
                
                  TekButton(
                    text: _isLogin ? 'Register instead' : 'Login instead',
                    // borderColor: const Color.fromRGBO(240, 240, 240, 0.9),
                    width: double.infinity,
                    type: TekButtonType.themeGhost,
                    onPressed: _switch,
                  ),
                TekVSpace.p18,
              ],
            ),
          ),
        ),
      )
    );
  }
}
