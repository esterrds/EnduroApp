import 'package:enduro_app/bloc/Connectivity/connectivity_cubit.dart';
import 'package:enduro_app/bloc/ContadorCubit/contador_cubit.dart';
import 'package:enduro_app/presentation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'alert/msg_alerta.dart';

//3 tracinhos
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    //conexão mqtt
    ConnectivityCubit conCubit = BlocProvider.of<ConnectivityCubit>(context);
    ContadorCubit carCubit = BlocProvider.of<ContadorCubit>(context);
    return Drawer(
      child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          return ListView(
            children: [
              Container(
                //design do primeiro container
                color: const Color.fromRGBO(0, 125, 83, 49),
                height: 50,
                child: IconButton(
                  onPressed: () {
                    //liga e desliga conexão
                    if (state is ConnectivityDisconnected) {
                      conCubit.mqttConnect();
                    } else if (state is ConnectivityConnected) {
                      conCubit.mqttDisconnect();
                    } else {
                      conCubit.mqttConnect();
                    }
                  },
                  icon: state is ConnectivityDisconnected
                      ? const SizedBox(
                          //desconectado
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.connect_without_contact,
                            color: Colors.black,
                          ),
                        )
                      : const SizedBox(
                          //conectado
                          width: 120,
                          height: 120,
                          child: Icon(
                            Icons.connect_without_contact,
                            color: Colors.yellow,
                          ),
                        ),
                ),
              ),
              Container(
                //design do segundo container
                color: midBlue,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        onPressed: () {
                          //enviar mensagens
                          if (state is ConnectivityDisconnected) {
                            alertFailed(context);
                          } else if (state is ConnectivityConnected) {
                            conCubit.publishTest(carCubit);
                            alertSucess(context);
                          } else {
                            wait(context);
                          }
                        },
                        icon: const Icon(Icons.cloud_upload_outlined)),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                height: 400,
                child: Image.asset('assets/images/logoVerde.jpeg'),
              ),
              Row(
                children: const [],
              ),
            ],
          );
        },
      ),
    );
  }
}
