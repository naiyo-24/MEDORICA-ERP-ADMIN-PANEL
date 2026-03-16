class MRMonthlyTarget {
  const MRMonthlyTarget({
    required this.id,
    required this.mrId,
    required this.mrName,
    required this.month,
    required this.year,
    required this.totalTarget,
    required this.targetAchieved,
  });

  final String id;
  final String mrId;
  final String mrName;
  final int month;
  final int year;
  final double totalTarget;
  final double targetAchieved;

  double get targetGap {
    final gap = totalTarget - targetAchieved;
    return gap > 0 ? gap : 0;
  }

  bool get isPastMonth {
    final now = DateTime.now();
    if (year < now.year) {
      return true;
    }
    if (year > now.year) {
      return false;
    }
    return month < now.month;
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  double get targetMissed => isPastMonth ? targetGap : 0;

  double get targetYetLeftToAchieve {
    if (isPastMonth) {
      return 0;
    }
    return targetGap;
  }

  double get progress {
    if (totalTarget <= 0) {
      return 0;
    }
    final value = targetAchieved / totalTarget;
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }
}
