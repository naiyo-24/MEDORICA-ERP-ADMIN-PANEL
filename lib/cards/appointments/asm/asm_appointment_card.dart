import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/asm_appointments.dart';
import '../../../theme/app_theme.dart';

class ASMAppointmentCard extends StatelessWidget {
  const ASMAppointmentCard({super.key, required this.appointment});

  final ASMAppointment appointment;

  String _date(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${value.day.toString().padLeft(2, '0')} ${months[value.month - 1]} ${value.year}';
  }

  String _time(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')} $period';
  }

  String _statusLabel(ASMAppointmentStatus status) {
    switch (status) {
      case ASMAppointmentStatus.scheduled:
        return 'Scheduled';
      case ASMAppointmentStatus.completed:
        return 'Completed';
      case ASMAppointmentStatus.cancelled:
        return 'Cancelled';
      case ASMAppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  Color _statusColor(ASMAppointmentStatus status) {
    switch (status) {
      case ASMAppointmentStatus.scheduled:
        return AppColors.primary;
      case ASMAppointmentStatus.completed:
        return Colors.green;
      case ASMAppointmentStatus.cancelled:
        return AppColors.error;
      case ASMAppointmentStatus.rescheduled:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(appointment.status);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  appointment.id,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  _statusLabel(appointment.status),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: [
              _InfoChip(
                icon: Iconsax.calendar_1,
                label: 'Date',
                value: _date(appointment.dateTime),
              ),
              _InfoChip(
                icon: Iconsax.clock,
                label: 'Time',
                value: _time(appointment.dateTime),
              ),
              _InfoChip(
                icon: Iconsax.user_octagon,
                label: 'ASM Name',
                value: appointment.asmName,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(label: 'Doctor', value: appointment.doctorName),
          _DetailRow(label: 'Doctor Phone', value: appointment.doctorPhone),
          _DetailRow(
            label: 'Doctor Specialization',
            value: appointment.doctorSpecialization,
          ),
          _DetailRow(label: 'Chamber Name', value: appointment.chamberName),
          _DetailRow(
            label: 'Chamber Address',
            value: appointment.chamberAddress,
          ),
          _DetailRow(
            label: 'Chamber Phone No',
            value: appointment.chamberPhone,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.quaternary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label: ',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.quaternary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.quaternary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
