import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepositTextfield extends StatelessWidget {
  const DepositTextfield({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.00, 0.00),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            padding: const EdgeInsets.only(left: 5),
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: const Color(0xFF3B4FFE),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        child: Text(
                          '+234',
                          style: TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 3, 0),
                        child: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 24,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 82, 82, 82),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                      child: TextFormField(
                        // controller: _model.textController,
                        // focusNode: _model.textFieldFocusNode,
                        autofocus: true,
                        textCapitalization: TextCapitalization.none,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: 'MiN. 100',
                          hintStyle: TextStyle(
                            fontFamily: 'Medium',
                            color: Color(0x75FFFFFF),
                            fontSize: 14,
                          ),
                          errorStyle: TextStyle(
                            fontFamily: 'Medium',
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.end,
                        maxLength: 11,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        buildCounter: (context,
                                {required currentLength,
                                required isFocused,
                                maxLength}) =>
                            null,
                        keyboardType: TextInputType.phone,
                        cursorColor: const Color(0xFF3B4FFE),
                        // validator: _model.textControllerValidator
                        // .asValidator(context),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
