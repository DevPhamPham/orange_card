import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:orange_card/app_theme.dart';
import 'package:orange_card/config/app_logger.dart';
import 'package:orange_card/resources/models/topic.dart';
import 'package:orange_card/resources/models/word.dart';
import 'package:orange_card/resources/services/TTSService.dart';
import 'package:orange_card/resources/viewmodels/TopicViewmodel.dart';
import 'package:orange_card/resources/viewmodels/WordViewModel.dart';
import 'package:orange_card/ui/FlashCard/components/bottomSheet.dart';
import 'package:orange_card/ui/FlashCard/components/cardItem.dart';
import 'package:orange_card/ui/FlashCard/components/results.dart';
import 'package:swipable_stack/swipable_stack.dart';

class FlashCard extends StatefulWidget {
  final TopicViewModel topicViewModel;
  final List<Word> words;
  final Topic topic;

  const FlashCard(
      {Key? key,
      required this.topicViewModel,
      required this.words,
      required this.topic})
      : super(key: key);

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  late Timer _timer;
  final TTSService textToSpeechService = TTSService();
  Color cardColor = Colors.white;
  bool isFrontStartSelected = false;
  bool isBackStartSelected = false;
  List<Word> currentWords = [];
  List<Word> leflWords = [];
  List<Word> rightWords = [];
  ValueNotifier<bool> _isFlipped = ValueNotifier<bool>(false);
  FlipCardController _flipCardController = FlipCardController();
  ValueNotifier<int> _currentIndexNotifier = ValueNotifier<int>(1);
  ValueNotifier<int> _currentLeftNumber = ValueNotifier<int>(0);
  ValueNotifier<int> _currentRightNumber = ValueNotifier<int>(0);
  SwipableStackController _swipableStackController = SwipableStackController();
  @override
  void initState() {
    super.initState();
    currentWords = widget.words;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startAutoAdvanceTimer() {
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_currentIndexNotifier.value < currentWords.length) {
        Future.delayed(const Duration(seconds: 2), () {
          _isFlipped.value = !_isFlipped.value;
        });
        Future.delayed(const Duration(seconds: 5), () {
          _swipableStackController.next(swipeDirection: SwipeDirection.right);
        });
        _currentIndexNotifier.value++; // Tăng chỉ số hiện tại
      } else {
        _timer.cancel();
      }
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return BottomSheetContent(
          words: widget.words,
          onFilter: (filteredWords) {
            setState(() {
              currentWords = filteredWords;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flash Card",
          style: AppTheme.title_appbar2,
        ),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(color: Colors.white),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
              child: const Icon(Icons.more_vert),
              onTap: () => _showBottomSheet(context))
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  widget.topicViewModel.topic.title!,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _currentLeftNumber,
                    builder: (context, value, _) {
                      return Text(
                        "Chưa thuộc $value",
                        style: const TextStyle(color: Colors.red),
                      );
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _currentIndexNotifier,
                    builder: (context, value, _) {
                      return Text(
                        "$value/${currentWords.length}",
                      );
                    },
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _currentRightNumber,
                    builder: (context, value, _) {
                      return Text(
                        "Đã thuộc $value",
                        style: const TextStyle(color: Colors.blue),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  child: SwipableStack(
                    controller: _swipableStackController,
                    stackClipBehaviour: Clip.none,
                    itemCount: currentWords.length,
                    allowVerticalSwipe: false,
                    builder: (context, properties) {
                      final itemIndex = properties.index % currentWords.length;
                      final english = currentWords[itemIndex].english;
                      final vietnamese = currentWords[itemIndex].vietnamese;
                      isFrontStartSelected = isBackStartSelected =
                          WordViewModel()
                              .checkMarked(currentWords[itemIndex].userMarked);
                      return FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        controller: _flipCardController,
                        onFlip: () {
                          _isFlipped.value;
                        },
                        front: CardItem(
                          color: Colors.white,
                          text: english!,
                          isStartSelected: isFrontStartSelected,
                          onTapSpeak: () async {
                            await textToSpeechService.speak(widget
                                .topicViewModel.words[itemIndex].english!);
                          },
                          onTapStar: () async {
                            bool isMarked = WordViewModel().checkMarked(
                                currentWords[itemIndex].userMarked);
                            if (isMarked) {
                              await WordViewModel().markWord(widget.topic.id!,
                                  currentWords[itemIndex].id!, false);
                            } else {
                              await WordViewModel().markWord(widget.topic.id!,
                                  currentWords[itemIndex].id!, true);
                            }
                            setState(() {
                              isFrontStartSelected = !isFrontStartSelected;
                            });
                          },
                        ),
                        back: CardItem(
                          color: Colors.white,
                          text: vietnamese,
                          isStartSelected: isBackStartSelected,
                          onTapSpeak: () async {
                            await textToSpeechService.speak(english);
                          },
                          onTapStar: () async {
                            bool isMarked = WordViewModel().checkMarked(
                                currentWords[itemIndex].userMarked);
                            if (isMarked) {
                              await WordViewModel().markWord(widget.topic.id!,
                                  currentWords[itemIndex].id!, false);
                            } else {
                              await WordViewModel().markWord(widget.topic.id!,
                                  currentWords[itemIndex].id!, true);
                            }
                            setState(() {
                              isBackStartSelected = !isBackStartSelected;
                            });
                          },
                        ),
                      );
                    },
                    overlayBuilder: (context, swipeProperty) {
                      final opacity =
                          swipeProperty.swipeProgress.clamp(0.0, 1.0);
                      return Opacity(
                          opacity: opacity,
                          child: CardItem(
                              text: "",
                              isStartSelected: true,
                              onTapSpeak: () {},
                              onTapStar: () {},
                              color:
                                  swipeProperty.direction == SwipeDirection.left
                                      ? Colors.redAccent
                                      : Colors.greenAccent));
                    },
                    onSwipeCompleted: (index, direction) {
                      if (direction == SwipeDirection.left) {
                        _currentLeftNumber.value += 1;
                        leflWords.add(currentWords[index]);
                      } else if (direction == SwipeDirection.right) {
                        _currentRightNumber.value += 1;
                        rightWords.add(currentWords[index]);
                      }
                      if (_currentIndexNotifier.value == currentWords.length) {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: ((_) => Center(
                                  child: ResultFlashCard(
                                    masterWord: _currentRightNumber.value,
                                    notmasterWord: _currentLeftNumber.value,
                                    onComplete: () {
                                      Navigator.pop(context);
                                    },
                                    onLearnNotMaster: () {
                                      logger.i(leflWords.length);
                                      resetData(leflWords);
                                      logger.i(currentWords.length);
                                    },
                                    onReuse: () {
                                      resetData(widget.words);
                                    },
                                  ),
                                )));
                      } else {
                        _currentIndexNotifier.value += 1;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 50,
            right: 100,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(90),
              ),
              child: GestureDetector(
                onTap: () {
                  _swipableStackController.next(
                      swipeDirection: SwipeDirection.right);
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 100,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(90),
              ),
              child: GestureDetector(
                onTap: () {
                  _swipableStackController.next(
                      swipeDirection: SwipeDirection.left);
                },
                child: const Icon(
                  Icons.clear,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetData(List<Word> words) {
    setState(() {
      currentWords = List.from(words);
      leflWords.clear();
      rightWords.clear();
      _currentIndexNotifier.value = 1;
      _currentLeftNumber.value = 0;
      _currentRightNumber.value = 0;
      _isFlipped.value = false;
      _swipableStackController.currentIndex = 0;
    });
  }
}
