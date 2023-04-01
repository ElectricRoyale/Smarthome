import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogbookItem extends StatefulWidget {
  final DateTime timestamp;
  final String status;
  final String message;

  const LogbookItem(this.timestamp, this.status, this.message, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LogbookItemLayout();
}

class _LogbookItemLayout extends State<LogbookItem> {
  TextOverflow _overflow = TextOverflow.ellipsis;
  final Map<String, Widget> _prefixes = {
    'ERROR': const Icon(
      Icons.error_rounded,
      color: Colors.red,
    ),
    'WARNING': const Icon(
      Icons.warning_rounded,
      color: Colors.yellow,
    ),
    'INFO': const Icon(
      Icons.info_rounded,
      color: Colors.blue,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _overflow = _overflow == TextOverflow.ellipsis
            ? TextOverflow.fade
            : TextOverflow.ellipsis;
        setState(() {});
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _prefixes[widget.status] ??
                const Icon(
                  Icons.info_rounded,
                  color: Colors.blue,
                ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message,
                      overflow: _overflow,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('HH:mm dd.MM.yyyy').format(widget.timestamp),
                      style: const TextStyle(color: Color(0xffb2b2b2)),
                    )
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
