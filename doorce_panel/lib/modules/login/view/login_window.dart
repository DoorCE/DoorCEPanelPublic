import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/login/view/controllers/c_login_window.dart';
import 'package:doorce_panel/modules/login/view/viewmodel/m_login_window.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class VLoginWindow extends StatefulWidget {
  final MLoginWindow _model;
  final CLoginWindow _cLoginWindow;

  const VLoginWindow(this._cLoginWindow, this._model, {super.key});

  @override
  State<VLoginWindow> createState() => _VLoginWindowState();
}

class _VLoginWindowState extends State<VLoginWindow> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + 60,
        backgroundColor: DoorColor.transparent,
        actions: [
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('images/doorce_logo.png', fit: BoxFit.contain),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBackground(),
          _buildLoginForm(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'images/doorce_data.png',
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + 50),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: DoorColor.reverse.withAlpha(150),
            border: Border.all(
              color: DoorColor.reverse.withAlpha(150),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: DoorColor.greyBlur.withAlpha(150),
                spreadRadius: 3,
                blurRadius: 8,
              ),
            ],
          ),
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DoorText(
                    AppLocalizations.of(context)!.login,
                    DoorTextStyle.main,
                  ),
                  const SizedBox(height: 20),
                  _buildEmailField(context),
                  const SizedBox(height: 15),
                  _buildPasswordField(context),
                  const SizedBox(height: 10),
                  if (_errorMessage.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: DoorColor.red, size: 14),
                        const SizedBox(width: 3),
                        DoorText(_errorMessage, DoorTextStyle.error),
                      ],
                    ),
                  const SizedBox(height: 20),
                  _buildLoginButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.email,
        hintText: AppLocalizations.of(context)!.emailHint,
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: DoorColor.reverse.withAlpha(80),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.fieldRequired;
        }
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(value)) {
          return AppLocalizations.of(context)!.unvalidEmail;
        }
        return null;
      },
      onChanged: (value) => widget._model.email = value,
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.password,
        hintText: AppLocalizations.of(context)!.passwordHint,
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        fillColor: DoorColor.reverse.withAlpha(80),
        filled: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.fieldRequired;
        }
        if (value.length < 6) {
          return AppLocalizations.of(context)!.unvalidPassword;
        }
        return null;
      },
      onChanged: (value) => widget._model.password = value,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: 196,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DoorButtonPlain(
              AppLocalizations.of(context)!.login,
              _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = "";
                        });

                        bool success = await widget._cLoginWindow
                            .onLoginPressed(context, widget._model);

                        setState(() {
                          _isLoading = false;
                          if (!success) {
                            _errorMessage =
                                AppLocalizations.of(context)!.loginFailed;
                          }
                        });
                      }
                    },
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                backgroundColor: DoorColor.darkEmph,
                strokeWidth: 5,
              ),
            ),
        ],
      ),
    );
  }
}

class VLoginWindowFactory {
  final CLoginWindow _cLoginWindow;
  const VLoginWindowFactory(this._cLoginWindow);

  VLoginWindow get(model) => VLoginWindow(_cLoginWindow, model);
}
