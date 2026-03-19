import '../../../models/onboarding/mr.dart';
import '../../../providers/onboarding/mr_onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../models/appointment/mr_appointments.dart';
import '../../../models/doctor_network/mr_doctor_network.dart';
import '../../../models/visual_ads.dart';
import '../../../providers/doctor_network/mr_doctor_network_provider.dart';
import '../../../providers/visual_ads_provider.dart';
import '../../../theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MRAppointmentCard extends ConsumerWidget {
  const MRAppointmentCard({super.key, required this.appointment});

  final MRAppointment appointment;


  MRDoctorNetwork _getDoctor(WidgetRef ref, String doctorId) {
    final doctorList = ref.watch(mrDoctorListProvider);
    return doctorList.firstWhere(
      (doc) => doc.doctorId == doctorId,
      orElse: () => const MRDoctorNetwork(
        id: 0,
        mrId: '',
        doctorId: '',
        doctorName: '',
        phoneNo: '',
        specialization: '',
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

  String _statusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  Color _statusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return AppColors.primary;
      case AppointmentStatus.completed:
        return Colors.green;
      case AppointmentStatus.cancelled:
        return AppColors.error;
      case AppointmentStatus.rescheduled:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        // Fetch MR name via provider
        MR getMR(WidgetRef ref, String mrId) {
          final mrList = ref.watch(mrListProvider);
          return mrList.firstWhere(
            (mr) => mr.mrId == mrId,
            orElse: () => const MR(mrId: '', name: '', phone: '', password: ''),
          );
        }
    final theme = Theme.of(context);
    final statusColor = _statusColor(appointment.status);
    final doctor = _getDoctor(ref, appointment.doctorId);
    final visualAdsNames = _getVisualAdsNames(ref, appointment.visualAdsRaw);
    final mr = getMR(ref, appointment.mrId);

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
              Chip(
                label: Text(_statusLabel(appointment.status)),
                backgroundColor: statusColor,
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                appointment.id,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.quaternary,
                  fontWeight: FontWeight.w600,
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
                icon: Iconsax.calendar,
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
                value: appointment.place ?? '-',
              ),
              _InfoChip(
                icon: Iconsax.user,
                label: 'Doctor',
                value: doctor.doctorName,
              ),
              _InfoChip(
                icon: Iconsax.user,
                label: 'MR',
                value: mr.name,
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
          if (appointment.appointmentProofImage != null) ...[
            const SizedBox(height: AppSpacing.md),
            const Divider(color: AppColors.border),
            const SizedBox(height: AppSpacing.sm),
            Text('Completion Photo Proof:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Image.network(
                appointment.appointmentProofImage!,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Center(
                      child: Icon(
                        Iconsax.gallery_slash,
                        size: 48,
                        color: AppColors.quaternary,
                      ),
                    ),
                  );
                },
              ),
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


