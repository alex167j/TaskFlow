import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/task.dart';
import 'tasks_view_model.dart';

/// Formulario para registrar una tarea.
///
/// Solo captura y valida datos locales; no hace HTTP. Al confirmar, entrega
/// la tarea al ViewModel y regresa al listado. La sesión 10 sustituirá el
/// alta en memoria por una solicitud POST a la API.
class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority? _priority;
  DateTime? _dueDate;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final today = DateTime.now();
    final firstDate = DateTime(today.year, today.month, today.day);
    final selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? firstDate,
      firstDate: firstDate,
      lastDate: DateTime(today.year + 1, 12, 31),
      helpText: 'Selecciona la fecha límite',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      fieldLabelText: 'Fecha límite',
    );

    if (!mounted || selected == null) return;
    setState(() => _dueDate = selected);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final viewModel = context.read<TasksViewModel>();
    final description = _descriptionController.text.trim();

    viewModel.addTask(
      Task(
        id: viewModel.nextTaskId,
        title: _titleController.text.trim(),
        description: description.isEmpty ? 'Sin descripción' : description,
        priority: _priority!,
        status: TaskStatus.pending,
        userId: 1,
        dueDate: _dueDate,
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tarea agregada al listado.')));
    context.pop();
  }

  String _priorityLabel(TaskPriority priority) => switch (priority) {
    TaskPriority.high => 'Alta',
    TaskPriority.medium => 'Media',
    TaskPriority.low => 'Baja',
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea'), centerTitle: true),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Completa los datos. El título y la prioridad son obligatorios.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            TextFormField(
              key: const Key('task-title-field'),
              controller: _titleController,
              textInputAction: TextInputAction.next,
              maxLength: 80,
              decoration: const InputDecoration(
                labelText: 'Título *',
                hintText: 'Por ejemplo: Entregar informe del taller',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Escribe un título para la tarea.';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: const Key('task-description-field'),
              controller: _descriptionController,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                hintText: 'Detalla qué debes hacer',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            FormField<TaskPriority>(
              key: const Key('task-priority-field'),
              validator: (value) =>
                  value == null ? 'Selecciona una prioridad.' : null,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prioridad *',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final priority in TaskPriority.values)
                          ChoiceChip(
                            key: Key('priority-${priority.name}'),
                            label: Text(_priorityLabel(priority)),
                            selected: state.value == priority,
                            onSelected: (selected) {
                              final value = selected ? priority : null;
                              state.didChange(value);
                              setState(() => _priority = value);
                            },
                          ),
                      ],
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.errorText!,
                          style: TextStyle(
                            color: colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Fecha límite (opcional)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDueDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(
                      _dueDate == null
                          ? 'Sin fecha'
                          : MaterialLocalizations.of(context)
                                .formatMediumDate(_dueDate!),
                    ),
                  ),
                ),
                if (_dueDate != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Quitar fecha',
                    onPressed: () => setState(() => _dueDate = null),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Guardar tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
