
import 'package:flutter/material.dart';

Image logoWidget(String imageName){
  return Image.asset(
    imageName,
    fit:BoxFit.fitWidth,
    width:240,
    height:240
  );

}

 TextFormField buildTextField(
  String text,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller,
  String? Function(String?)? validator,
  bool isButtonEnabled,
) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    validator: validator,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.9)),
      filled: true,
      fillColor: Colors.grey[200],
      floatingLabelBehavior: FloatingLabelBehavior.never,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: 0, style: BorderStyle.none),
      ),
      errorText: isButtonEnabled ? (validator != null ? validator(controller.text) : null) : null,
    ),
    keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}


Container signInSignUpButon(BuildContext context,bool isLogIn,Function onTap,bool isEnabled){
  return Container(
    width:MediaQuery.of(context).size.width,
    height:50,
    margin:const EdgeInsets.fromLTRB(0,10,0,20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90.0)),
    child:ElevatedButton(
      onPressed:isEnabled?(){onTap();}:null ,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
        if(states.contains(MaterialState.pressed)){
          return Colors.black26;
        }
        return Colors.white;
        }
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)))
        
      ),
      child:Text(
        isLogIn?"Log In":"Sign Up",
        style:const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 16)
      ),
      )
  );
  


}