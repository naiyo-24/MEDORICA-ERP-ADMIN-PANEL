import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

class AuthState {
	const AuthState({
		this.user,
		this.isLoading = false,
		this.errorMessage,
	});

	final User? user;
	final bool isLoading;
	final String? errorMessage;

	bool get isAuthenticated => user != null;

	AuthState copyWith({
		User? user,
		bool? isLoading,
		String? errorMessage,
		bool clearError = false,
	}) {
		return AuthState(
			user: user ?? this.user,
			isLoading: isLoading ?? this.isLoading,
			errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
		);
	}
}

class AuthNotifier extends Notifier<AuthState> {
	@override
	AuthState build() {
		return const AuthState();
	}

	Future<bool> login({required String email, required String password}) async {
		state = state.copyWith(isLoading: true, clearError: true);

		await Future<void>.delayed(const Duration(milliseconds: 900));

		if (!_isValidEmail(email)) {
			state = state.copyWith(
				isLoading: false,
				errorMessage: 'Please enter a valid email address.',
			);
			return false;
		}

		if (password.length < 6) {
			state = state.copyWith(
				isLoading: false,
				errorMessage: 'Password must be at least 6 characters.',
			);
			return false;
		}

		final user = User(
			id: 'ADM-001',
			name: 'Medorica Admin',
			email: email,
			role: 'Administrator',
		);

		state = state.copyWith(user: user, isLoading: false, clearError: true);
		return true;
	}

	void logout() {
		state = const AuthState();
	}

	bool _isValidEmail(String value) {
		return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
	}
}
