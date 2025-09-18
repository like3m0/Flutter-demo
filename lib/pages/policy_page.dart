import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xiangyue/utils/screen_util.dart';
import 'package:xiangyue/widgets/custom/div_custom.dart';
import 'package:xiangyue/widgets/custom/image_custom.dart';
import 'package:xiangyue/widgets/custom/text_custom.dart';
import 'package:provider/provider.dart';
import 'package:xiangyue/model/theme_setting.dart';

class PolicyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PolicyPageState();
  }
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Positioned(
            top: getSize(20),
            left: getSize(20),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: ImageCustom(name: "icon_fanhui", width: 23.5),
            )),
        Positioned(
          //拉丝背景图
          top: getSize(64),
          left: 0,
          right: 0,
          bottom: 0,
          child: DivCustom(
              padding: [0, 0, 0, 0],
              child: ImageCustom(
                width: 375,
                height: 1750,
                name: Provider.of<ThemeSettings>(context, listen: true)
                    .getBackgroundImageName(),
                boxFit: BoxFit.fill,
              )),
        ),
        Positioned(
            //页面标题
            top: getSize(90),
            left: 0,
            right: 0,
            height: getSize(22),
            child: TextCustom(
              text: "Policy",
              color: "#ffffffff",
              size: 21.5,
              weight: FontWeight.w500,
            )),
        Positioned(
          top: getSize(125),
          left: 0,
          bottom: 0,
          right: 0,
          child: DivCustom(
            margin: [0, 20, 50, 20],
            padding: [0, 5, 0, 5],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(getSize(22)),
              child: DivCustom(
                  color: Provider.of<ThemeSettings>(context, listen: false)
                      .getBackgroundColorString(),
                  padding: [15, 15, 15, 15],
                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    slivers: [
                      SliverToBoxAdapter(
                          child: SizedBox(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // DivCustom(height: 10),
                              Text(
                                "I. DISCLAIMER",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "II. TERMS OF USE",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "I. DISCLAIMER",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "Do not operate this application or any handheld device while driving. This application is intended for passenger use. When the driver uses this application, operate it only when the vehicle gear shift is in \"Park\". Always obey all traffic laws.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "II. TERMS OF USE",
                                textAlign: TextAlign.left,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 15),
                              Text(
                                "By choosing to “Agree” and download this application from this website or ALPSALPINE, installing or using this application or any portion thereof (“Application”), you agree to the following terms and conditions (the “Terms and Conditions”).",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "1. USE OF APPLICATION.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• ALPSALPINE grants you the non-exclusive, non-transferable, limited right and license to install and use this Application solely and exclusively for your personal use.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• You may not use the Application in any manner that could damage, disable, overburden, or impair the Application (or servers or networks connected to the Application), nor may you use the Application in any manner that could interfere with any other party’s use and enjoyment of the Application (or servers or networks connected to the Application).",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• You may not use the Application to distribute or utilize any content or language which may be patently offensive or promotes racism, bigotry, hatred or physical harm of any kind against any group, individual or entity. ALPSALPINE may, in its sole discretion, disable or terminate any account it deems to contain or use any of the preceding offensive content.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• You agree that you are solely responsible for (and that ALPSALPINE has no responsibility to you or to any third party for) your use of the Application, any breach of your obligations under the Terms and Conditions, and for the consequences of any such breach, including any loss or damage which ALPSALPINE may suffer.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "2. PROPRIETARY RIGHTS. You acknowledge that:",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• The Application contains proprietary and confidential information that is protected by applicable intellectual property and other laws;",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• ALPSALPINE and/or third parties own all right, title and interest in and to the Application and content (excluding content provided by you) that may be presented or accessed through the Application, including without limitation all Intellectual Property Rights therein and thereto. “Intellectual Property Rights” means any and all rights existing from time to time under patent law, copyright law, trade secret law, trademark law, unfair competition law, and any and all other proprietary rights, and any and all applications, renewals, extensions and restorations thereof, now or hereafter in force and effect worldwide. You agree that you will not, and will not allow any third party to, (i) copy, sell, license, distribute, transfer, modify, adapt, translate, prepare derivative works from, decompile, reverse engineer, disassemble or otherwise attempt to derive source code from the Application or content that may be presented or accessed through the Application for any purpose, unless otherwise permitted, (ii) take any action to circumvent or defeat the security or content usage rules provided, deployed or enforced by any functionality (including without limitation digital rights management functionality) contained in the Application, (iii) use the Application to access, copy, transfer, transcode or retransmit content in violation of any law or third party rights, or (iv) remove, obscure, or alter ALPSALPINE’s or any third party’s copyright notices, trademarks, or other proprietary rights notices affixed to or contained within or accessed in conjunction with or through the Application.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 100,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "3. EXPORT RESTRICTIONS. The Application may be subject to export controls or restrictions by each countries or territories. You agree to comply with all applicable international export laws and regulations. These laws include restrictions on destinations, end users, and end use.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "4. TERMINATION. These Terms and Conditions will continue to apply until terminated by either you or ALPSALPINE as set forth below. You may terminate these Terms and Conditions at any time by permanently deleting the Application from your mobile device in its entirety. Your rights automatically and immediately terminate without notice from ALPSALPINE or any Third Party if you fail to comply with any provision of these Terms and Conditions. In such event, you must immediately delete the Application.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 50,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "5. INDEMNITY. To the maximum extent permitted by law, you agree to defend, indemnify and hold harmless ALPSALPINE, its affiliates and their respective directors, officers, employees and agents from and against any and all claims, actions, suits or proceedings, as well as any and all losses, liabilities, damages, costs and expenses (including reasonable attorneys fees) arising out of or accruing from your use of the Application, including your downloading, installation, or use of the Application, or your violation of these Terms and Conditions.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 50,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "6. DISCLAIMER OF WARRANTIES.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• YOU EXPRESSLY UNDERSTAND AND AGREE THAT YOUR USE OF THE APPLICATION IS AT YOUR SOLE DISCRETION AND RISK AND THAT THE APPLICATION IS PROVIDED AS IS AND AS AVAILABLE WITHOUT WARRANTY OF ANY KIND.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• YOU ARE SOLELY RESPONSIBLE FOR ANY DAMAGE TO YOUR MOBILE DEVICE, OR OTHER DEVICE, OR LOSS OF DATA THAT RESULTS FROM SUCH USE.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• ALPSALPINE FURTHER EXPRESSLY DISCLAIMS ALL WARRANTIES AND CONDITIONS OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO THE IMPLIED WARRANTIES AND CONDITIONS OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT, WITH RESPECT TO THE APPLICATION.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• THE APPLICATION IS NOT INTENDED FOR USE IN THE OPERATION OF NUCLEAR FACILITIES, LIFE SUPPORT SYSTEMS, EMERGENCY COMMUNICATIONS, AIRCRAFT NAVIGATION OR COMMUNICATION SYSTEMS, AIR TRAFFIC CONTROL SYSTEMS, OR ANY OTHER ACTIVITIES IN WHICH THE FAILURE OF THE APPLICATION COULD LEAD TO DEATH, PERSONAL INJURY, OR SEVERE PHYSICAL OR ENVIRONMENTAL DAMAGE.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 30,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "7. LIMITATION OF LIABILITY. YOU EXPRESSLY UNDERSTAND AND AGREE THAT ALPSALPINE, ITS SUBSIDIARIES AND AFFILIATES, AND ITS LICENSORS ARE NOT LIABLE TO YOU UNDER ANY THEORY OF LIABILITY FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL CONSEQUENTIAL OR EXEMPLARY DAMAGES THAT MAY BE INCURRED BY YOU THROUGH YOUR USE OF THE APPLICATION, INCLUDING ANY LOSS OF DATA OR DAMAGE TO YOUR MOBILE DEVICE, WHETHER OR NOT ALPSALPINE OR ITS REPRESENTATIVES HAVE BEEN ADVISED OF OR SHOULD HAVE BEEN AWARE OF THE POSSIBILITY OF ANY SUCH LOSSES ARISING.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 50,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "8. MISCELLANEOUS.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 10,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• These Terms and Conditions constitute the entire Agreement between you and ALPSALPINE relating to the Application and govern your use of the Application, and completely replace any prior or contemporaneous agreements between you and ALPSALPINE regarding the Application.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• The failure of ALPSALPINE to exercise or enforce any right or provision of these Terms and Conditions does not constitute a waiver of such right or provision, which will still be available to ALPSALPINE.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 20,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• If any court of law, having the jurisdiction to decide on this matter, rules that any provision of these Terms and Conditions is invalid, then that provision will be removed from the Terms and Conditions without affecting the rest of the Terms and Conditions. The remaining provisions of these Terms and Conditions will continue to be valid and enforceable.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 30,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• The rights granted in these Terms and Conditions may not be assigned or transferred by either you or ALPSALPINE without the prior written approval of the other party. Neither you nor ALPSALPINE are permitted to delegate their responsibilities or obligations under these Terms and Conditions without the prior written approval of the other party.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 30,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                              DivCustom(height: 10),
                              Text(
                                "• These Terms and Conditions and your relationship with ALPSALPINE under these Terms and Conditions will be governed by the laws of the State of California without regard to its conflict of laws provisions. You and ALPSALPINE agree to submit to the exclusive jurisdiction of the courts located within the county of Los Angeles, California to resolve any legal matter arising from these Terms and Conditions. Notwithstanding this, you agree that ALPSALPINE will still be allowed to apply for injunctive remedies (or an equivalent type of urgent legal relief) in any jurisdiction.",
                                textAlign: TextAlign.start,
                                textDirection: TextDirection.ltr,
                                maxLines: 50,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 1.3,
                                    fontWeight: FontWeight.w400),
                              ),
                            ]),
                      ))
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeSettings>(context, listen: false)
          .getBackgroundColor(),
      body: DivCustom(
          padding: [MediaQuery.of(context).padding.top, 0, 0, 0],
          child: _buildBody()),
    );
  }
}
