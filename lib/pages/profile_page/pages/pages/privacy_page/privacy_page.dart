import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Түрээсийн нөхцөл',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrivacyTextSection(
                title: '1. Үл хөдлөх хөрөнгийн өмчлөл ба түрээс',
                content:
                    'Гадаадын иргэд тодорхой төрлийн үл хөдлөх хөрөнгийг өмчлөх, эсвэл урт хугацаагаар газар түрээслэх боломжтой.',
              ),
              PrivacyTextSection(
                title: '2. Татварын асуудлууд',
                content:
                    'Монгол Улсад үл хөдлөх хөрөнгийн татвар нь хөрөнгийн төрөл, байршлаас хамаарч өөр өөр байдаг.',
              ),
              PrivacyTextSection(
                title: '3. Бүртгэл ба оршин суух шаардлага',
                content:
                    'Монгол Улсад 30-аас дээш хоног түр хугацаагаар оршин суух гадаадын иргэд бүртгүүлэх шаардлагатай.',
              ),
              PrivacyTextSection(
                title: '4. Түр хугацааны түрээсийн платформууд',
                content:
                    'Улаанбаатар хотод Airbnb зэрэг платформууд идэвхтэй ажиллаж байна.',
              ),
              PrivacyTextSection(
                title: '5. Зохицуулалтын орчин',
                content:
                    'Түрээсийн байранд аюулгүй байдал, чанарын стандартуудыг хангах шаардлагатай.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivacyTextSection extends StatelessWidget {
  final String title;
  final String content;

  const PrivacyTextSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
