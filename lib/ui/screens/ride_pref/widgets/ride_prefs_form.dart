import 'package:flutter/material.dart';
import '../../../../model/ride/locations.dart';
import '../../../../model/ride_pref/ride_pref.dart';
import 'location_picker.dart';
import '../../../../utils/date_time_utils.dart';
import 'package:flutter/services.dart';
import '../../../theme/theme.dart';
import 'bla_button.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;

  const RidePrefForm({super.key, this.initRidePref});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate = DateTime.now();
  Location? arrival;
  late int requestedSeats = 1;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    // TODO

    //  If we are creating a new ride preference, the fields start empty or with default values.
    // If we are editing an existing ride preference, we pass the old data to the form, and it uses those values to pre-fill the fields.

    if (widget.initRidePref != null) {
      departure = widget.initRidePref!.departure;
      arrival = widget.initRidePref!.arrival;
      departureDate = widget.initRidePref!.departureDate;
      requestedSeats = widget.initRidePref!.requestedSeats;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void _swapLocations() {
    setState(() {
      final temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  Future<void> _selectDeparture() async {
    final selected = await showLocationPicker(context, title: 'Select Departure');
    if (selected != null) setState(() => departure = selected);
  }

  Future<void> _selectArrival() async {
    final selected = await showLocationPicker(context, title: 'Select Arrival');
    if (selected != null) setState(() => arrival = selected);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) setState(() => departureDate = picked);
  }

  bool _isFormValid() {
    return departure != null &&
        arrival != null &&
        requestedSeats > 0;
  }

  void _onSearch() {
    if (!_isFormValid()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Please fill all fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.pop(
      context,
      RidePref(
        departure: departure!,
        arrival: arrival!,
        departureDate: departureDate,
        requestedSeats: requestedSeats,
      ),
    );
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------

  String _getLocationDisplay(Location? location) {
    if (location == null) return '';
    return '${location.name}, ${location.country.name}';
  }

  // ----------------------------------
  // Build the widgets
  // ----------------------------------

@override
Widget build(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: EdgeInsets.all(BlaSpacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLocationField(
              value: departure,
              hint: 'Leaving from',
              onTap: _selectDeparture,
              trailing: IconButton(
                icon: Icon(Icons.swap_vert, color: BlaColors.primary),
                onPressed: _swapLocations,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
            Divider(height: 1, color: BlaColors.greyLight),
            _buildLocationField(
              value: arrival,
              hint: 'Going to',
              onTap: _selectArrival,
            ),
            Divider(height: 1, color: BlaColors.greyLight),
            _buildDateField(),
            Divider(height: 1, color: BlaColors.greyLight),
            _buildSeatsField(),
            BlaButton(
              text: 'Search',
              onPressed: _isFormValid() ? _onSearch : null,
              type: BlaButtonType.primary,
            ),
          ],
        ),
      ), 
    ],
  ); 
}

  Widget _buildLocationField({
    required Location? value,
    required String hint,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: BlaSpacings.m),
        child: Row(
          children: [
            Icon(Icons.radio_button_off_outlined, color: BlaColors.neutralLight, size: 20),
            SizedBox(width: BlaSpacings.m),
            Expanded(
              child: Text(
                value != null ? _getLocationDisplay(value) : hint,
                style: BlaTextStyles.body.copyWith(
                  color: value != null ? BlaColors.neutralDark : BlaColors.neutralLight,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
  
  Widget _buildDateField() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: BlaSpacings.m),
        child: Row(
          children: [
            Icon(Icons.calendar_month, color: BlaColors.neutralLight, size: 20),
            SizedBox(width: BlaSpacings.m),
            Expanded(
              child: Text(
                DateTimeUtils.formatDateTime(departureDate),
                style: BlaTextStyles.body.copyWith(color: BlaColors.neutralLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatsField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: BlaSpacings.s),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: BlaColors.neutralLight, size: 25),
          SizedBox(width: BlaSpacings.m),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(hintText: '1', border: InputBorder.none),
              style: BlaTextStyles.body.copyWith(color: BlaColors.neutralDark),
              onChanged: (value) {
                setState(() {
                  requestedSeats = int.tryParse(value) ?? 1;
                });
              },
            ),
          ),
        ],
      ),
    );
  }


}