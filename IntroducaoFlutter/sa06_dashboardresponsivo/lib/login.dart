import 'package:flutter/material.dart';

// Aqui estamos criando um widget com estado, o que significa que ele pode mudar durante o uso.
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> { // O estado desse widget vai gerenciar as mudanças. Ele guarda informações sobre o email, senha e se o tema é claro ou escuro.

  final _formKey = GlobalKey<FormState>();  // Esta chave vai ser usada para validar o formulário e salvar os dados.

  String _email = '';
  String _senha = ''; // Variáveis para armazenar os dados inseridos pelo usuário.
  
  bool _modoEscuro = false;  // Aqui estamos controlando se o modo escuro está ativado ou não.

  @override
  Widget build(BuildContext context) {
    // Dependendo do modo escuro ou claro, as cores dos textos, fundo e campos mudam.
    Color textoPrincipal = _modoEscuro ? Colors.white : Colors.white;  // Texto sempre branco, tanto no modo escuro quanto no claro.
    Color fundo = _modoEscuro ? Colors.black : Colors.white;
    Color corCampo = _modoEscuro ? Colors.grey[800]! : Colors.blue;

    return Scaffold(
      backgroundColor: fundo,  // A cor de fundo vai ser preta ou branca, dependendo do tema.
      appBar: AppBar(
        backgroundColor: Colors.blue,  // A cor da barra de navegação superior (AppBar).
        title: Text(
          "LOGIN",  // O título da tela vai ser "LOGIN".
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),  // O título vai ser branco e em negrito.
        ),
        centerTitle: true,  // O título fica centralizado.
        actions: [
          // Este ícone vai mudar entre o ícone de luz e escuridão, dependendo do tema.
          IconButton(
            icon: Icon(
              _modoEscuro ? Icons.dark_mode : Icons.light_mode,  // O ícone vai alternar entre os modos.
              color: Colors.white,
            ),
            onPressed: () {
              // Quando o usuário clicar no ícone, o tema vai alternar entre claro e escuro.
              setState(() {
                _modoEscuro = !_modoEscuro;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),  // Adicionando um pouco de espaço ao redor do formulário.
          width: 300,  // A caixa vai ter 300 de largura.
          decoration: BoxDecoration(
            color: _modoEscuro ? Colors.grey[900] : Colors.black,  // O fundo da caixa vai ser preto ou cinza, dependendo do tema.
            borderRadius: BorderRadius.circular(10),  // As bordas da caixa vão ser arredondadas.
            boxShadow: [
              BoxShadow(
                color: _modoEscuro ? Colors.black54 : Colors.blueGrey,  // A sombra da caixa vai ser mais escura no modo escuro e azulada no claro.
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: Form(
            key: _formKey,  // O formulário está vinculado à chave para validação.
            child: Column(
              mainAxisSize: MainAxisSize.min,  // A coluna vai usar o mínimo de espaço possível.
              crossAxisAlignment: CrossAxisAlignment.start,  // Tudo vai ser alinhado à esquerda.
              children: [
                // Texto que diz ao usuário o que ele precisa inserir.
                Text(
                  "Digite seu email",
                  style: TextStyle(color: textoPrincipal),  // O texto vai ser branco, independentemente do tema.
                ),
                // Campo de entrada para o email.
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,  // Preenche o campo de fundo com uma cor.
                    fillColor: corCampo,  // A cor de fundo do campo depende do tema.
                    border: InputBorder.none,  // Não tem borda visível no campo.
                  ),
                  keyboardType: TextInputType.emailAddress,  // Vai aparecer o teclado específico para email no celular.
                  validator: (value) {
                    // Validando o email, garantindo que não esteja vazio e tenha o formato correto.
                    if (value == null || value.isEmpty) {
                      return 'Email é obrigatório';
                    } else if (!value.contains('@')) {
                      return 'Digite um e-mail válido';
                    }
                    return null;  // Se estiver tudo certo, retorna null (sem erro).
                  },
                  onSaved: (value) {
                    // Quando o formulário for salvo, o valor do email será armazenado.
                    if (value != null) {
                      _email = value;
                    }
                  },
                ),
                SizedBox(height: 10),  // Espaço entre os campos de entrada.
                // Texto informando o que o usuário precisa inserir no próximo campo.
                Text(
                  "Digite sua senha",
                  style: TextStyle(color: textoPrincipal),  // O texto vai ser branco.
                ),
                // Campo de entrada para a senha.
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,  // Preenche o campo de fundo com uma cor.
                    fillColor: corCampo,  // A cor do campo depende do tema.
                    border: InputBorder.none,  // Removendo a borda do campo.
                  ),
                  obscureText: true,  // A senha será mascarada para segurança.
                  validator: (value) {
                    // Validando se a senha não está vazia.
                    if (value == null || value.isEmpty) {
                      return 'Senha é obrigatória';
                    }
                    return null;  // Se a senha estiver ok, retorna null.
                  },
                  onSaved: (value) {
                    // Salvando o valor da senha quando o formulário for enviado.
                    if (value != null) {
                      _senha = value;
                    }
                  },
                ),
                SizedBox(height: 20),  // Espaço antes do botão de login.
                // Botão de login que vai validar o formulário.
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,  // A cor de fundo do botão será azul.
                      foregroundColor: Colors.white,  // O texto do botão será branco.
                    ),
                    onPressed: () {
                      // Quando o botão for pressionado, validamos o formulário.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Se o formulário for válido, navegamos para a próxima tela ("/tarefas").
                        Navigator.pushNamed(context, "/tarefas");
                      }
                    },
                    child: Text("Login"),  // O texto do botão é "Login".
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
