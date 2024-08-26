import 'package:flutter/material.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldkey;
  final bool? ispasswordfield;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldsubmitted;
  final TextInputType? inputType;

  const FormContainerWidget(
      {
      Key? key,
      this.controller,
      this.fieldkey,
      this.ispasswordfield,
      this.hintText,
      this.labelText,
      this.helperText,
      this.onSaved,
      this.validator,
      this.onFieldsubmitted,
      this.inputType});

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText =true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.35),
        borderRadius: BorderRadius.circular(10),

      ),
      child: new TextField(
        
        style: TextStyle(color: Colors.blue),
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldkey,
        obscureText: widget.ispasswordfield == true?_obscureText:false,
        


        decoration: new InputDecoration(
          border: InputBorder.none,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black45),
          suffixIcon: new GestureDetector(
            onTap: (){
              setState(() {
                _obscureText=!_obscureText;
              });

            },
            child:
            widget.ispasswordfield==true? Icon(_obscureText? Icons.visibility_off : Icons.visibility, color: _obscureText==false ? Colors.blue : Colors.grey,):Text(""),
          )

        ),
      
      ),
    );
  }
}