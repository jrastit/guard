import 'package:web3dart/web3dart.dart';

final Map<EtherUnit, int> _myfactors = {
  EtherUnit.wei: 0,
  EtherUnit.kwei: 3,
  EtherUnit.mwei: 6,
  EtherUnit.gwei: 9,
  EtherUnit.szabo: 12,
  EtherUnit.finney: 15,
  EtherUnit.ether: 18
};

final charDot = '.'.codeUnitAt(0);
final char0 = '0'.codeUnitAt(0);
final char9 = '9'.codeUnitAt(0);

class MyEtherAmount extends EtherAmount {
  MyEtherAmount(EtherAmount etherAmount) : super.inWei(etherAmount.getInWei);

  MyEtherAmount.inWei(super.value) : super.inWei();

  toStringUnit(EtherUnit unit) {
    int myfactor = _myfactors[unit] ?? 0;
    if (getInWei == BigInt.zero) {
      return '0';
    }
    String result = getInWei.toString();
    if (myfactor > 0) {
      if (result.length < myfactor + 1) {
        result = '0'.padLeft(1 + myfactor - result.length, '0') + result;
      }
      result =
          '${result.substring(0, result.length - myfactor)}.${result.substring(result.length - myfactor)}';
      result =
          result.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return result;
  }

  factory MyEtherAmount.fromStringUnit(EtherUnit unit, String s) {
    int myfactor = _myfactors[unit] ?? 0;
    BigInt result = BigInt.zero;
    bool isDecimal = false;
    for (int i = 0; i < s.length; i++) {
      var char = s.codeUnitAt(i);
      if (char == charDot) {
        if (isDecimal) {
          throw ArgumentError('Invalid amount');
        }
        isDecimal = true;
        continue;
      }
      if (char > char9 || char < char0) {
        throw ArgumentError('Invalid amount');
      }
      result = result * BigInt.from(10) + BigInt.from(char - char0);
      if (isDecimal) {
        myfactor--;
        if (myfactor == -1) {
          throw ArgumentError('Invalid amount');
        }
      }
    }
    return MyEtherAmount.inWei(result * BigInt.from(10).pow(myfactor));
  }

  // Add any additional methods or properties specific to MyEtherAmount here
}
