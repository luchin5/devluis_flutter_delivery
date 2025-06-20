import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoCategoria extends StatefulWidget {
  const TodoCategoria({Key? key}) : super(key: key);

  @override
  State<TodoCategoria> createState() => _TodoCategoriaState();
}

class _TodoCategoriaState extends State<TodoCategoria> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(1, 37, 255, 1),
          title: Text(
            "Categorías",
            style: GoogleFonts.manrope(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.r),
          child: Container(
            height: 1.sh - 130.h,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push('/allcategoria_sub');
                        },
                        child: Container(
                          width: 80.w,
                          height: 71.h,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              borderRadius: BorderRadius.circular(15.r),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://solvida.sfo3.cdn.digitaloceanspaces.com/icons_file/3dicons-star-dynamic-color.png"))),
                        ),
                      ),
                      Text(
                        "Accesorios",
                        style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(1, 37, 255, 1)),
                      )
                    ],
                  );
                }),
          ),
        ));
  }
}
