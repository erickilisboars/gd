import gd
import os

fn main() {
	// Largura e altura da imagem.
	width := 720
	height := 405

	// Cria a imagem final.
	mut image := gd.gd_image_create_truecolor(width, height)

	// Aloca a cor de fundo branca.
	bg_color := gd.gd_image_color_allocate(image, 230, 230, 230)

	// Preenche o fundo.
	gd.gd_image_fill(image, 0, 0, bg_color)

	// Aloca a cor preta para o texto.
	text_color := gd.gd_image_color_allocate(image, 93, 135, 191)

	// Carrega o arquivo PNG do logo.
	logo_file := C.fopen(c'assets/v-logo.png', c'rb')
	mut logo_image := gd.gd_image_create_from_png(logo_file)
	C.fclose(logo_file)

	// Define as novas dimensões para o logo.
	resized_width := 190
	resized_height := 190

	// Calcula a posição x para centralizar o logo redimensionado.
	logo_x := (width - resized_width) / 2
	// Define a posição y do logo (com uma pequena margem superior).
	logo_y := 50

	// Copia o logo redimensionado para a imagem principal, usando a função
	// image_copy_resampled para garantir a transparência e qualidade.
	// Esta função substitui image_copy_resized e image_copy.
	gd.gd_image_copy_resampled(image, logo_image, logo_x, logo_y, 0, 0, resized_width,
		resized_height, logo_image.sx, logo_image.sy)

	// Libera a memória da imagem do logo original.
	gd.gd_image_destroy(logo_image)

	// Nome do arquivo da fonte TrueType.
	font_name := os.join_path(os.getwd(), 'assets', 'Gilroy-Black.ttf')
	font_size := 50.0 // Tamanho da fonte.

	// Texto a ser escrito na imagem.
	text := 'V + GD'

	// Cria uma imagem temporária para calcular a caixa de limites do texto.
	mut temp_image := gd.gd_image_create_truecolor(1, 1)
	_ := gd.gd_image_color_allocate(temp_image, 0, 0, 0)
	mut brect := []int{len: 8}

	// Calcula a caixa de limites do texto.
	gd.gd_image_string_ft(temp_image, brect.data, text_color, font_name.str, font_size,
		0.0, 0, 0, text.str)
	gd.gd_image_destroy(temp_image)

	// Obtém a largura e altura do texto a partir da caixa de limites.
	text_width := brect[2] - brect[0]
	text_height := brect[1] - brect[5]

	// Define a margem entre o logo e o texto.
	margin := 20

	// Calcula a posição x e y para centralizar o texto abaixo do logo.
	text_x := (f64(width) - f64(text_width)) / 2
	text_y := f64(logo_y) + f64(resized_height) + f64(text_height) + f64(margin)

	// Desenha o texto na imagem principal.
	mut error_msg := gd.gd_image_string_ft(image, unsafe { nil }, text_color, font_name.str,
		font_size, 0.0, int(text_x), int(text_y), text.str)
	if error_msg != unsafe { nil } {
		println('Erro ao desenhar o texto: ${error_msg}')
	}

	// Habilita a preservação do canal alfa antes de salvar, para que a transparência seja mantida.
	gd.gd_image_save_alpha(image, 1)

	file := C.fopen(c'output.png', c'wb')
	gd.gd_image_png(image, file)
	C.fclose(file)

	// Libera a memória alocada pela imagem.
	gd.gd_image_destroy(image)
}
