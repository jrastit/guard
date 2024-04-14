import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hans/action/wallet_action.dart';
import 'package:hans/model/wallet.dart';
import 'package:hans/service/state_service.dart';
import 'package:hans/widget/form_item_title.dart';
import 'package:hans/widget/loading_widget.dart';
import 'package:tekflat_design/tekflat_design.dart';

class WalletSection extends StatefulWidget {
  final Function setAddress;
  final String? address;
  final List<WalletMeta> wallets;
  final Function(AppState appState) setAppState;

  const WalletSection({
    super.key,
    required this.address,
    required this.wallets,
    required this.setAddress,
    required this.setAppState,
  });

  @override
  State<WalletSection> createState() => _WalletSectionState();
}

class _WalletSectionState extends State<WalletSection> {
  final _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController _address = TextEditingController();

  bool _loading = false;

  void _getCustodialWallet() async {
    setState(() {
      _loading = true;
    });
    await WalletAction.walletCustodial();
    widget.setAppState(AppState.retrieveWallet);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const LoadingWidget(title: 'Creating wallet...');
    }

    WalletMeta? walletCustodial;

    for (var wallet in widget.wallets) {
      if (wallet.type == WalletType.custodial) {
        walletCustodial = wallet;
        break;
      }
    }

    return SingleChildScrollView(
        child: Center(
      child: SizedBox(
        width: 350,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TekVSpace.mainSpace,
              TekTypography(
                text: 'Address : ${widget.address ?? ''}',
              ),
              TekVSpace.mainSpace,
              FormItemTitleWidget(
                title: 'Address',
                isRequired: true,
                child: TekInput(
                  key: const Key('address'),
                  name: 'address',
                  controller: _address,
                  prefixIcon: const Icon(Icons.person),
                  validator: FormBuilderValidators.required(
                    errorText: 'Address is required',
                  ),
                ),
              ),
              if (walletCustodial != null)
                TekButton(
                  key: const Key('Custodialaddress'),
                  text: 'Use Custodial address',
                  width: double.infinity,
                  type: TekButtonType.primary,
                  onPressed: () {
                    _address.text = walletCustodial?.address ?? '';
                  },
                ),
              if (walletCustodial == null)
                TekButton(
                  key: const Key('Custodialaddress'),
                  text: 'Get a Custodial secure wallet',
                  width: double.infinity,
                  type: TekButtonType.primary,
                  onPressed: _getCustodialWallet,
                ),
              TekVSpace.mainSpace,
              
              for (var wallet in widget.wallets)
                  Column(
                    children: [
                      TekVSpace.mainSpace,
                      TekButton(
                        key: Key(wallet.address),
                        text: 'Use wallet ${wallet.address}',
                        width: double.infinity,
                        type: TekButtonType.primary,
                        onPressed: () {
                          _address.text = wallet.address;
                        },
                      ),
                    ],
                  ),
              TekVSpace.mainSpace,
              TekButton(
                key: const Key('setAddress'),
                text: 'Set Address',
                width: double.infinity,
                type: TekButtonType.success,
                onPressed: () {
                  if (_formKey.currentState!.saveAndValidate()) {
                    widget.setAddress(_address.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
