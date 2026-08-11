import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/app/theme/app_theme_extensions.dart';
import 'package:task_management_app/core/constants/app_strings.dart';
import 'package:task_management_app/features/tasks/presentation/controllers/task_controller.dart';
import 'package:task_management_app/features/tasks/presentation/widgets/task_board_keys.dart';

/// Reusable task creation form for bottom sheets, dialogs, and side panels.
class TaskForm extends ConsumerStatefulWidget {
  const TaskForm({
    super.key,
    this.onSuccess,
    this.autofocusTitle = false,
    this.showHeader = true,
  });

  final VoidCallback? onSuccess;
  final bool autofocusTitle;
  final bool showHeader;

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  final _titleFocusNode = FocusNode();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.autofocusTitle) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ref
          .read(taskControllerProvider.notifier)
          .addTask(title: _titleController.text, note: _noteController.text);

      _titleController.clear();
      _noteController.clear();
      widget.onSuccess?.call();
    } on ArgumentError {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.invalidTitleMessage)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.errorAddTask)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>() ?? AppSpacing.standard;

    return Form(
      key: _formKey,
      child: Column(
        key: TaskBoardKeys.taskForm,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showHeader) ...[
            Text(
              AppStrings.createTask,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: spacing.md),
          ],
          TextFormField(
            controller: _titleController,
            focusNode: _titleFocusNode,
            textInputAction: TextInputAction.next,
             decoration: const InputDecoration(
              labelText: AppStrings.titleLabel,
              hintText: AppStrings.titleHint,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.titleRequired;
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          SizedBox(height: spacing.md),
          TextFormField(
            controller: _noteController,
            minLines: 2,
            maxLines: 4,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: AppStrings.noteLabel,
              hintText: AppStrings.noteHint,
              alignLabelWithHint: true,
            ),
            onFieldSubmitted: (_) => _submit(),
          ),
          SizedBox(height: spacing.lg),
          FilledButton(
            onPressed: _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.onPrimary,
                    ),
                  )
                : const Text(AppStrings.addTask),
          ),
        ],
      ),
    );
  }
}
