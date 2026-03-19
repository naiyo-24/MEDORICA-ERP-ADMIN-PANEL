import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/appointment/asm_appointments.dart';
import '../../../models/onboarding/asm.dart';
import '../../../models/doctor_network/asm_doctor_network.dart';
import '../../../models/visual_ads.dart';
import '../../../providers/onboarding/asm_onboarding_provider.dart';
import '../../../providers/doctor_network/asm_doctor_network_provider.dart';
import '../../../providers/visual_ads_provider.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ASMAppointmentCard extends ConsumerWidget {
  const ASMAppointmentCard({super.key, required this.appointment});

  final ASMAppointment appointment;

  ASM _getASM(WidgetRef ref, String asmId) {
    final asmList = ref.watch(asmListProvider);
    return asmList.firstWhere(
      (asm) => asm.asmId == asmId,
      orElse: () => const ASM(asmId: '', name: '', phone: '', password: ''),
    );
  }

  ASMDoctorNetwork _getDoctor(WidgetRef ref, String doctorId) {
    final doctorList = ref.watch(asmDoctorListProvider);
    return doctorList.firstWhere(
      (doc) => doc.doctorId == doctorId,
      orElse: () => const ASMDoctorNetwork(
        id: 0,
        asmId: '',
        doctorId: '',
        doctorName: '',
        specialization: '',
        phoneNo: '',
      ),
    );
  }

  List<String> _getVisualAdsNames(WidgetRef ref, List<dynamic>? visualAdsRaw) {
    final adsList = ref.watch(visualAdsListProvider);
    if (visualAdsRaw == null) return [];
    return visualAdsRaw.map((ad) {
      if (ad is Map && ad['id'] != null) {
        final adObj = adsList.firstWhere(
          (a) => a.id == ad['id'],
          orElse: () => VisualAd(adId: '', name: '', createdAt: DateTime(2000)),
        );
        return adObj.name.isNotEmpty ? adObj.name : (ad['medicine_name']?.toString() ?? '');
      }
      return '';
    }).where((name) => name.isNotEmpty).toList();
  }

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
  Widget build(BuildContext context, WidgetRef ref) {
        // DEBUG: Print provider lists and appointment fields
        final debugDoctorList = ref.watch(asmDoctorListProvider);
        if (kDebugMode) {
          print('DEBUG: asmDoctorListProvider contents:');
        }
        for (final doc in debugDoctorList) {
          if (kDebugMode) {
            print('doctorId: ${doc.doctorId}, doctorName: ${doc.doctorName}');
          }
        }
        if (kDebugMode) {
          print('DEBUG: appointment.doctor_id: ${appointment.doctor_id}');
        }

        final debugVisualAdsList = ref.watch(visualAdsListProvider);
        if (kDebugMode) {
          print('DEBUG: visualAdsListProvider contents:');
        }
        for (final ad in debugVisualAdsList) {
          if (kDebugMode) {
            print('id: ${ad.id}, name: ${ad.name}');
          }
        }
        if (kDebugMode) {
          print('DEBUG: appointment.visual_ads: ${appointment.visual_ads}');
        }
    final theme = Theme.of(context);
    final statusColor = _statusColor(appointment.status);
    final asm = _getASM(ref, appointment.asmId);
    final doctor = _getDoctor(ref, appointment.doctor_id ?? '');
    final visualAdsNames = _getVisualAdsNames(ref, appointment.visual_ads);

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
                  color: statusColor.withAlpha(26),
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
                icon: Iconsax.location,
                label: 'Place',
                value: appointment.place != null ? appointment.place! : '-',
              ),
              _InfoChip(
                icon: Iconsax.user_octagon,
                label: 'ASM Name',
                value: asm.name,
              ),
              _InfoChip(
                icon: Iconsax.user,
                label: 'Doctor',
                value: doctor.doctorName,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (visualAdsNames.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppSpacing.sm),
            Text('Visual Ads:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.md,
              children: visualAdsNames.map((name) => Chip(label: Text(name))).toList(),
            ),
          ],
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

