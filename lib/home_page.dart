import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:s_voice_assistant/feature_box.dart';
import 'package:s_voice_assistant/openai_service.dart';
import 'package:s_voice_assistant/pallette.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastwords = '';

  final OpenAIService openAIService = OpenAIService();
  String? generateContent;
  String? generateImageUrl;
  int start = 200;
  int delay = 200;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastwords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('S Voice AI')),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Virtual Assistant Icon
            (generateContent == null && generateImageUrl == null)
                ? ZoomIn(
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            height: 120,
                            width: 120,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: const BoxDecoration(
                                color: Pallete.assistantCircleColor,
                                shape: BoxShape.circle),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              generateContent = null;
                              generateImageUrl = null;
                              setState(() {});
                            },
                            child: Container(
                              height: 125,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/virtualAssistant.png'))),
                            )),
                      ],
                    ),
                  )
                : ZoomIn(
                    child: InkWell(
                      onTap: () {
                        generateContent = null;
                        generateImageUrl = null;
                        setState(() {});
                      },
                      child: Container(
                        height: 200,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/virtual-assistant-abstract.png'))),
                      ),
                    ),
                  ),
            //welcome chat bubble
            FadeInRight(
              child: Visibility(
                visible: generateImageUrl == null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: BorderRadius.circular(20)
                          .copyWith(topLeft: Radius.zero)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      generateContent == null
                          ? 'Hi! What Can I do for you?'
                          : generateContent!,
                      style: TextStyle(
                        color: Pallete.mainFontColor,
                        fontSize: generateContent == null ? 25 : 18,
                        fontFamily: 'Cera Pro',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (generateImageUrl != null && generateContent == null)
              Padding(
                padding: const EdgeInsets.all(10.0).copyWith(top: 34),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(generateImageUrl!)),
              ),

            //Suggestion text
            SlideInLeft(
              child: Visibility(
                visible: generateContent == null && generateImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Here are few features you can try!',
                    style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.mainFontColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            //feaures
            Visibility(
              visible: generateContent == null && generateImageUrl == null,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(
                        color: Pallete.firstSuggestionBoxColor,
                        header: 'Chat GPT',
                        desc:
                            'Access ChatGPT in a smarter way like ever before'),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                        color: Pallete.secondSuggestionBoxColor,
                        header: 'Dall E',
                        desc:
                            'Get inspired and stay creative with your personal assistant powered by dall-E'),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(
                        color: Pallete.thirdSuggestionBoxColor,
                        header: 'Smart Voice assistant',
                        desc:
                            'Get the best of bot worlds with a voice assistant powere by Dall-E and Chat GPT'),
                  )
                ],
              ),
            ),
            Container(
              height: 45,
            ),
            ZoomIn(
              child: FloatingActionButton(
                onPressed: () async {
                  if (await speechToText.hasPermission &&
                      speechToText.isNotListening) {
                    startListening();
                  } else if (speechToText.isListening) {
                    print(lastwords);
                    final speech =
                        await openAIService.isArtPromptAPI(lastwords);
                    if (speech.contains('https')) {
                      generateImageUrl = speech;
                      generateContent = null;
                      setState(() {});
                    } else {
                      generateImageUrl = null;
                      generateContent = speech;
                      await systemSpeak(speech);
                      setState(() {});
                    }

                    await stopListening();
                  } else {
                    initSpeechToText();
                  }
                },
                child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
              ),
            )
          ],
        ),
      ),
    );
  }
}
