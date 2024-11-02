from reactpy import component, html, run, hooks
from myreactpy_database import obras

@component
def Galeria():
    indice_obra, set_indice_obra = hooks.use_state(0)
    
    def obra_anterior(evento):
        #print(evento)
        if indice_obra - 1 < 0:
            set_indice_obra(0)
        else:
            set_indice_obra(indice_obra - 1)

    def obra_proxima(evento):
        #print(evento)
        if indice_obra + 1 >= len(obras):
            set_indice_obra(len(obras) - 1)
        else:
            set_indice_obra(indice_obra + 1)


    obra = obras[indice_obra]
    nome = obra["name"]
    artista = obra["artist"]
    descricao = obra["description"]
    imagem_url = obra["url"]


    componente = html.div(
        {
            "style": {
                "width": "75%",
                "margin_left": "5%",
                "background-color": "lightblue",
                "border": "5px outset red",
                "display": "block",
                "height": "480px",
                "padding": "10px",
            },
        },
        html.div(
            {
                "style": {
                    "display": "block",
                    "height": "400px",
                    "overflow": "auto",
                },
            },
            html.h3(nome), # nome
            html.img({"src": imagem_url, "style":{"height": "200px"}, "border": "solid"}), # foto da obra
            html.p(descricao), # descricao
            html.p(f"Artista: {artista}"), # nome do artista: Artista: Fulano
            ),
        html.div(
            html.button({"on_click": obra_anterior}, "Anterior"), # Anterior
            html.button({"on_click": obra_proxima}, "Próxima"), # Próxima
            html.p(f"Obra {indice_obra + 1} de {len(obras)}"), # Obra 2 de 9
        )
    )
    return componente

@component
def App():
    pagina = html.div(
        html.h1("Obras de Arte"),
        Galeria(),
    )
    return pagina


run(App)