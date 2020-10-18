import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:simple_rsa/simple_rsa.dart';

class Crypto {
  static final PUBLIC_KEY =
      "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3dksm5gZiV5PT1POR8BP3YZ5iVc2NI7qB76OFcFhWT9ep57s2dy3hEjyk21UunLP6rCA0DWbRV7LJBgSfxxuobelMGJKbSpO5bC0G5I7ATw8ZJ/shCSWoDVa1pyigXW7dwQQHDs4UHVAefJQu48XTUPobCMBzATrDlIqBabOX8ZJ+nge6Y8nZeOXkGdv1Ymgscy4MfXVSzUxnBhAGKHUU3fD99bdfiqiPUBIO6GOA6QrMOhy5ZsrW41QqNg5VDwOnSvH0jVSN6y7lhIPl89VFbYbez11k8iLITQXe4h7cU7qFWaenOVT/KRFk2pdB3m+FSNBzc/fFqpnKRv6/8YZdQIDAQAB";
  static final PRIVATE_KEY =
      "MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDd2SybmBmJXk9PU85HwE/dhnmJVzY0juoHvo4VwWFZP16nnuzZ3LeESPKTbVS6cs/qsIDQNZtFXsskGBJ/HG6ht6UwYkptKk7lsLQbkjsBPDxkn+yEJJagNVrWnKKBdbt3BBAcOzhQdUB58lC7jxdNQ+hsIwHMBOsOUioFps5fxkn6eB7pjydl45eQZ2/ViaCxzLgx9dVLNTGcGEAYodRTd8P31t1+KqI9QEg7oY4DpCsw6HLlmytbjVCo2DlUPA6dK8fSNVI3rLuWEg+Xz1UVtht7PXWTyIshNBd7iHtxTuoVZp6c5VP8pEWTal0Heb4VI0HNz98WqmcpG/r/xhl1AgMBAAECggEANMs13mE30oTrAsnC0ThmySTzT0e90owgDW+/iFXYwNBfyiv72Wy5D3X8pDDkdOpVqFgQj3vyU3PXi+Neo3k0qq91VCpP4+Kpm+eNNPJ7sDORe7DDLD84yS9pSqFD2uMVlaEV5GIDaMI+ccbEh53pwa1jZjh+ePrCpUnQTj//5LJuAWwuO1RCPIKSlFxp+kqSY8vP7ke4Ow+h8pH0Lh8Byya7DTmatotFcylUgdrITKr4jgp6lQBMI4lwrVZL/655xkQgzVjm3FWyJAz/YIiq9KHy3AyVC8VRUn9Zk578XY5xpYBoVLUNlWfHlhS6dbeDRS8DgVe+bFAsG5CCQ5SIkQKBgQDxLnN4+U3kbLL8vfjetjVZzP/eqFAXbFwcspVkhSKL9LlX/Td5sIeCCpGjssVdtklf6+a7Z17qoLk7cyDd4FsMk39tsXwh5amhJ/eal/H5R5C+GZbroOJlOznwdxwoV8BoX4Wwi7IMT6JgApgmHxjp+sWljBEuPba95qmAZlISTwKBgQDreqHWuvcsgXt4POE7l2iN1L5YBqpthnmIbw+VQV9f1xYJ89ld5EGwiiiTJg6DTX96CL+nnMjfjxMLlASMiEIGwMME8gM/VfFE8p10L7qArwJgoa0WMC9F4HNr1/aqe0ZtbE7gdSytNUpusca3Kb2329JnhxeHnQd7obTlB4P6+wKBgEzGGqABzFfQelGWL6jFm8oQRcsdDRHHvrKr7n5nGw4uQunNg2FLXnd44c+YUtd39XeBYpt5Vm+d5hkUlvvKNXGValUC0J8BurPAQ0OE5tQRgfPhtXcgabEL32+6ms4E0Qzoi2gdr/nXR7sEWGaaM5YX69687aMopglhacejyrBlAoGARcyJ4D53Ocf/szpIgQN2SGRBL5J6PhDYQWq6McG45Y25yKVxTvVzy0KImGV1c9Iq8R9av/InUKz2Nj5fwtA40gudQwABmmp9I7TOmzvyimZVzBLgXW1W9d18GQFg6lO0IocyMjJJVeYv8/PaNTy4MaGFEo7mmJohN7JNDn5VzrUCgYAuU9N/ArOsF6VuQ5nbadfwwmSXeEAofUd4u1EaBi+3yMx3Wq2TgJHAkSnmnCQWuV1Hc71KYXIMmIg7AkP1ZzruZcIPLc+nk8vMANliEDHSDjDJ6EhhIS/eYPnaHsZsydlR2NppRzM1Xh3TxPv9WC7k/ksX8b9fhFz/PokPyyBeKA==";

  static Future<String> endCryptData(
      {@required String textDataToEncrypt}) async {
    try {
      final String data = await encryptString(textDataToEncrypt, PUBLIC_KEY);
      return data;
    } catch (ex) {
      return "";
    }
  }

  static Future<String> deCryptData(
      {@required String textDataToDeCrypt}) async {
    try {
      final String decryptedText = await decryptString(
          "JwVpj1a75Jb9wU3B1cx8XxBU04BxeRM4H+sd6IkFaBntyhZ5YE16vBzBuPY5ENPgDN6uv77eA1r3EL+0HVhvjx0hInzWzK+RBoQECYWN8sxXu7QSCjLWK7JP4cjgVt61NOSD3r1ILPuhnL+ZGN+F5qq+qWh5MN9MpnSp4eSpd/YIAYaEmHVFWBhUytAex0HVLFcsh54HluMdA6y5LsTc+w+7kq9hn+62XqWGhitzblXitgHdjADCguDA880MQ0e+3zBehsrctDf004W/5k3YnGCTZM2eiS142LKgN8drFD34B/XZAGAP2hoPaXp9I6zqTWpicSZpfFetZwrIbinDRQ==",
          PRIVATE_KEY);
      return decryptedText;
    } catch (ex) {
      return "";
    }
  }
}
