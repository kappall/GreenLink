import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/event/widgets/date_time_selector.dart';
import 'package:intl/intl.dart';

import '../widgets/button.dart';

class CreateEventPage extends ConsumerStatefulWidget {
  const CreateEventPage({super.key});

  @override
  ConsumerState<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends ConsumerState<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

  EventType _selectedType = EventType.cleaning;
  int? _maxParticipants;
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 1, hours: 2));

  String? _locationLabel;
  double? _latitude;
  double? _longitude;
  bool _isLocating = false;
  bool _isPublishing = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    setState(() => _isLocating = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final p = placemarks.first;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationLabel = "${p.street}, ${p.locality}";
      });
    } catch (e) {
      if (mounted) {
        FeedbackUtils.showError(context, "Impossibile ottenere la posizione");
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _showLocationDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Inserisci Indirizzo"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Es: Via Roma 1, Milano",
            helperText: "Specifica città e via per risultati migliori",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () async {
              final address = controller.text.trim();
              if (address.isEmpty) return;

              Navigator.pop(context);
              setState(() => _isLocating = true);

              try {
                final locations = await geo.locationFromAddress(address);
                if (locations.isNotEmpty) {
                  final loc = locations.first;
                  final placemarks = await geo.placemarkFromCoordinates(
                    loc.latitude,
                    loc.longitude,
                  );

                  String resolvedLabel = address;
                  if (placemarks.isNotEmpty) {
                    final p = placemarks.first;
                    final parts = [
                      p.street,
                      p.locality,
                      p.administrativeArea,
                    ].where((s) => s != null && s.isNotEmpty).toList();
                    if (parts.isNotEmpty) {
                      resolvedLabel = parts.join(", ");
                    }
                  }

                  setState(() {
                    _latitude = loc.latitude;
                    _longitude = loc.longitude;
                    _locationLabel = resolvedLabel;
                  });
                } else {
                  if (mounted) {
                    FeedbackUtils.showError(context, "Indirizzo non trovato");
                  }
                }
              } catch (e) {
                if (mounted) {
                  FeedbackUtils.showError(context, "Errore nella ricerca: $e");
                }
              } finally {
                if (mounted) setState(() => _isLocating = false);
              }
            },
            child: const Text("Cerca"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    DateTime initial = isStart ? _startDate : _endDate;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initial),
      );

      if (time != null) {
        setState(() {
          final newDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          if (isStart) {
            _startDate = newDateTime;
            if (_endDate.isBefore(_startDate)) {
              _endDate = _startDate.add(const Duration(hours: 2));
            }
          } else {
            if (newDateTime.isBefore(_startDate)) {
              FeedbackUtils.showError(
                context,
                "La fine non può essere prima dell'inizio",
              );
            } else {
              _endDate = newDateTime;
            }
          }
        });
      }
    }
  }

  Future<void> _showMaxParticipantsPicker(
    FormFieldState<int> fieldState,
  ) async {
    final options = List<int>.generate(10000, (index) => index + 1);
    final initialIndex = fieldState.value != null
        ? options.indexOf(fieldState.value!)
        : 0;
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    int tempSelection = fieldState.value ?? options.first;
    final textController =
        TextEditingController(text: tempSelection.toString());

    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Annulla"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, tempSelection),
                      child: const Text("Conferma"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: "Inserisci numero",
                  ),
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null &&
                        parsed >= 1 &&
                        parsed <= 7000000000) {
                      tempSelection = parsed;
                    }
                  },
                ),
              ),
              SizedBox(
                height: 220,
                child: CupertinoPicker(
                  scrollController: controller,
                  itemExtent: 44,
                  useMagnifier: true,
                  magnification: 1.08,
                  onSelectedItemChanged: (index) {
                    tempSelection = options[index];
                    textController.text = tempSelection.toString();
                  },
                  children: options
                      .map((value) => Center(child: Text(value.toString())))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _maxParticipants = selected);
      fieldState.didChange(selected);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _latitude == null) {
      if (_latitude == null) {
        FeedbackUtils.showError(context, "Seleziona una posizione");
      }
      return;
    }

    setState(() => _isPublishing = true);
    try {
      await ref
          .read(eventsProvider(null).notifier)
          .createEvent(
            title: _titleController.text,
            description: _descriptionController.text,
            latitude: _latitude!,
            longitude: _longitude!,
            eventType: _selectedType,
            maxParticipants: _maxParticipants!,
            startDate: _startDate,
            endDate: _endDate,
          );

      if (mounted) {
        FeedbackUtils.showSuccess(context, "Evento creato con successo!");
        context.pop();
      }
    } catch (e) {
      if (mounted) FeedbackUtils.showError(context, e);
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text("Crea Evento")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              "Tipo di Evento",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: EventType.values
                  .where((e) => e != EventType.unknown)
                  .map((type) {
                    final isSelected = _selectedType == type;
                    return ChoiceChip(
                      label: Text(type.name.toUpperCase()),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _selectedType = type),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Titolo",
                border: OutlineInputBorder(),
              ),
              maxLength: 200,
              validator: (v) => v!.isEmpty ? "Inserisci un titolo" : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Descrizione",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              maxLength: 2000,
              validator: (v) => v!.isEmpty ? "Inserisci una descrizione" : null,
            ),
            const SizedBox(height: 20),
            FormField<int>(
              initialValue: _maxParticipants,
              validator: (v) => v == null ? "Seleziona un numero" : null,
              builder: (state) {
                final displayValue =
                    state.value != null ? state.value.toString() : "Seleziona";
                final textStyle = TextStyle(
                  color: state.value == null
                      ? Theme.of(context).hintColor
                      : Colors.black,
                );

                return InkWell(
                  onTap: () => _showMaxParticipantsPicker(state),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Partecipanti massimi",
                      border: const OutlineInputBorder(),
                      errorText: state.errorText,
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    child: Text(displayValue, style: textStyle),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Posizione",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _locationLabel ?? "Nessuna posizione selezionata",
                  style: TextStyle(
                    color: _locationLabel != null ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _isLocating ? null : _pickLocation,
                        icon: _isLocating
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(_isLocating ? "Cercando..." : "Attuale"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: _isLocating ? null : _showLocationDialog,
                        icon: const Icon(Icons.edit_location_alt),
                        label: const Text("Inserisci"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              "Programmazione",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DateTimeSelector(
              label: "Inizio",
              date: dateFormat.format(_startDate),
              time: timeFormat.format(_startDate),
              onTap: () => _pickDateTime(true),
            ),
            const SizedBox(height: 12),
            DateTimeSelector(
              label: "Fine",
              date: dateFormat.format(_endDate),
              time: timeFormat.format(_endDate),
              onTap: () => _pickDateTime(false),
            ),
            const SizedBox(height: 32),
            ButtonWidget(
              label: _isPublishing ? "Creazione..." : "Crea Evento",
              onPressed: _isPublishing ? null : _submit,
              icon: _isPublishing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
