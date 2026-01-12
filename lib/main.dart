import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/* ================== APP ================== */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clock',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}


/* ================== HOME ================== */
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;


  final tabs = <Widget>[];

  @override
  void initState() {
    super.initState();


    tabs.addAll([
      Screen1(),
      Screen2(),
      Screen3(),
      Screen4(),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("時鐘"),
        centerTitle: true,
      ),
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.public), label: "世界時鐘"),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: "鬧鐘"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "計時器"),
          BottomNavigationBarItem(icon: Icon(Icons.av_timer), label: "碼表"),
        ],
      ),
    );
  }
}

/* ================== Screen1 世界時鐘 ================== */

/// =======================
/// 資料結構
/// =======================
class WorldClock {
  final String city;
  final int offset;

  WorldClock({
    required this.city,
    required this.offset,
  });
}

/// =======================
/// 儲存物件（Store）
/// =======================
class WorldClockStore {
  static final WorldClockStore instance = WorldClockStore._internal();
  WorldClockStore._internal();

  final List<WorldClock> _clocks = [
    WorldClock(city: "台灣", offset: 8),
  ];

  List<WorldClock> get clocks => _clocks;

  void addClock(WorldClock clock) {
    if (_clocks.length >= 5) return;
    if (_clocks.any((c) => c.city == clock.city)) return;
    _clocks.add(clock);
  }

  void removeClock(int index) {
    _clocks.removeAt(index);
  }
}

/// =======================
/// Screen1
/// =======================
class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final WorldClockStore store = WorldClockStore.instance;

  DateTime now = DateTime.now().toUtc();

  final List<String> weekDay = ["一", "二", "三", "四", "五", "六", "日"];

  final Map<String, int> worldTimeZones = {
    "台灣": 8,
    "東京": 9,
    "首爾": 9,
    "北京": 8,
    "香港": 8,
    "新加坡": 8,
    "曼谷": 7,
    "倫敦": 0,
    "巴黎": 1,
    "德國": 1,
    "莫斯科": 3,
    "杜拜": 4,
    "華盛頓": -5,
    "洛杉磯": -8,
    "舊金山": -8,
  };


  String selectedCity = "東京";

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() {
        now = DateTime.now().toUtc();
      });
    }
  }
  void showAddClockDialog() {
    String tempSelectedCity = worldTimeZones.keys.first;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("新增世界時鐘"),
              content: DropdownButton<String>(
                value: tempSelectedCity,
                isExpanded: true,
                items: worldTimeZones.keys.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setDialogState(() {
                    tempSelectedCity = value!;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("取消"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      store.addClock(
                        WorldClock(
                          city: tempSelectedCity,
                          offset: worldTimeZones[tempSelectedCity]!,
                        ),
                      );
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("確定"),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "世界時鐘",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: store.clocks.length,
            itemBuilder: (context, index) {
              WorldClock wc = store.clocks[index];
              DateTime cityTime = now.add(Duration(hours: wc.offset));

              String dateText =
                  "${cityTime.year}/${cityTime.month.toString().padLeft(2, '0')}/${cityTime.day.toString().padLeft(2, '0')} "
                  "星期${weekDay[cityTime.weekday - 1]}";

              String timeText =
                  "${cityTime.hour.toString().padLeft(2, '0')}:"
                  "${cityTime.minute.toString().padLeft(2, '0')}:"
                  "${cityTime.second.toString().padLeft(2, '0')}";

              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(wc.city, style: const TextStyle(fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dateText),
                      Text(
                        timeText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        store.removeClock(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed:
            store.clocks.length >= 5 ? null : showAddClockDialog,
            child: const Text("新增世界時鐘（最多 5 個）"),
          ),
        ),
      ],
    );
  }
}


/* ================== Screen2 鬧鐘 ================== */
/// 資料結構
class Alarm {
  TimeOfDay time;
  bool enabled;
  List<bool> weekdays;

  Alarm(this.time)
      : enabled = true,
        weekdays = List.filled(7, true);

  Alarm clone() => Alarm(time)
    ..enabled = enabled
    ..weekdays = List.from(weekdays);
}


/// 儲存物件（Store）
class AlarmStore {
  static final AlarmStore instance = AlarmStore._internal();
  AlarmStore._internal();

  final List<Alarm> _alarms = [];

  List<Alarm> get alarms => _alarms;

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
  }

  void removeAlarm(int index) {
    _alarms.removeAt(index);
  }
}


 /*Screen2*/
class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final AlarmStore store = AlarmStore.instance;
  Timer? timer;

  final List<String> weekNames = ["一", "二", "三", "四", "五", "六", "日"];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      checkAlarms();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkAlarms() {
    final now = DateTime.now();
    final weekdayIndex = now.weekday - 1;

    for (Alarm alarm in store.alarms) {
      if (!alarm.enabled) continue;
      if (!alarm.weekdays[weekdayIndex]) continue;

      if (alarm.time.hour == now.hour &&
          alarm.time.minute == now.minute) {
          //判斷是否該呼叫鈴聲funtion
      }
    }
  }

  void showAlarmDialog({Alarm? alarm}) {
    Alarm tempAlarm = alarm?.clone() ?? Alarm(TimeOfDay.now());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("鬧鐘設定"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? t = await showTimePicker(
                        context: context,
                        initialTime: tempAlarm.time,
                      );
                      if (t != null) {
                        setDialogState(() {
                          tempAlarm.time = t;
                        });
                      }
                    },
                    child: Text(
                      "時間：${tempAlarm.time.format(context)}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (index) {
                      return FilterChip(
                        label: Text("週${weekNames[index]}"),
                        selected: tempAlarm.weekdays[index],
                        onSelected: (v) {
                          setDialogState(() {
                            tempAlarm.weekdays[index] = v;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("取消"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (alarm == null) {
                        store.addAlarm(tempAlarm);
                      } else {
                        alarm.time = tempAlarm.time;
                        alarm.weekdays = tempAlarm.weekdays;
                        alarm.enabled = tempAlarm.enabled;
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("確定"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String weekdayText(List<bool> days) {
    String result = "";
    for (int i = 0; i < 7; i++) {
      if (days[i]) result += "週${weekNames[i]} ";
    }
    return result.isEmpty ? "未選擇" : result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "鬧鐘",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: store.alarms.length,
            itemBuilder: (context, index) {
              Alarm alarm = store.alarms[index];
              return Card(
                margin:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  onTap: () => showAlarmDialog(alarm: alarm),
                  title: Text(
                    alarm.time.format(context),
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(weekdayText(alarm.weekdays)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: alarm.enabled,
                        onChanged: (v) {
                          setState(() {
                            alarm.enabled = v;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            store.removeAlarm(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton(
            onPressed: () => showAlarmDialog(),
            child: const Text("新增鬧鐘"),
          ),
        ),
      ],
    );
  }
}


/* ================== Screen3 計時器 ================== */

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;
  bool isPaused = false;

  bool firstLoad = true; // 初次切換頁面不跳出對話框

  void startTimer() {
    if (seconds <= 0) return;
    isRunning = true;
    isPaused = false;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds <= 0) {
        t.cancel();
        setState(() {
          isRunning = false;
          isPaused = false;
        });

        // 計時器歸零，跳出對話框
        if (!firstLoad) {
          showTimeUpDialog();
        }
      } else {
        setState(() {
          seconds--;
        });
      }
    });

    firstLoad = false; // 已經開始過一次，不算初次
  }

  void showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("時間到!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("確定"),
          ),
        ],
      ),
    );
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = true;
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      seconds = 0;
      isRunning = false;
      isPaused = false;
    });
  }

  String formatTime(int sec) {
    int m = sec ~/ 60;
    int s = sec % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("計時器",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          IconButton(
            icon: const Icon(Icons.add_circle, size: 40),
            onPressed: isRunning
                ? null
                : () {
              setState(() {
                seconds += 10;
              });
            },
          ),
          Text(formatTime(seconds),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.remove_circle, size: 40),
            onPressed: isRunning
                ? null
                : () {
              setState(() {
                if (seconds >= 10) seconds -= 10;
              });
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: isRunning ? null : startTimer,
                  child: Text(isPaused ? "繼續" : "開始")),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: isRunning ? pauseTimer : null,
                  child: const Text("暫停")),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: stopTimer, child: const Text("停止")),
            ],
          ),
        ],
      ),
    );
  }
}


/* ================== Screen4 碼表 ================== */
class Screen4 extends StatefulWidget {
  const Screen4({super.key});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  int milliseconds = 0;
  Timer? timer;
  bool isRunning = false;
  final Stopwatch stopwatch = Stopwatch();

  void start() {
    if (isRunning) return;
    stopwatch.start();
    isRunning = true;

    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        milliseconds = stopwatch.elapsedMilliseconds;
      });
    });
  }

  void stop() {
    stopwatch.stop();
    isRunning = false;
    timer?.cancel();
    setState(() {});
  }

  void reset() {
    stopwatch.reset();
    timer?.cancel();
    isRunning = false;
    milliseconds = 0;
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("碼表",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text("${(milliseconds / 1000).toStringAsFixed(1)} 秒",
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: start, child: const Text("開始")),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: stop, child: const Text("停止")),
              const SizedBox(width: 10),
              ElevatedButton(onPressed: reset, child: const Text("重置")),
            ],
          ),
        ],
      ),
    );
  }
}
