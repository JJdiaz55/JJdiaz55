module semaforo_concurrente(
    input clk, // Reloj de entrada
    output wire red, // LED para la luz roja
    output wire yellow, // LED para la luz amarilla
    output wire green // LED para la luz verde
);

reg [2:0] state; // Estado actual del semáforo
reg [31:0] count; // Contador para la temporización

// Estados del semáforo
parameter RED = 3'b001;
parameter RED_YELLOW = 3'b011; // Estado para rojo y amarillo juntos
parameter YELLOW = 3'b010;
parameter GREEN = 3'b100;
parameter GREEN_YELLOW = 3'b110; // Estado para verde y amarillo juntos

// Inicialización
initial begin
    state = RED;
    count = 0;
end

// Lógica del contador de tiempo
always @(posedge clk) begin
    count <= count + 1;
    case(state)
        RED: begin
            if(count >= 1000000) begin // Ajustar según la duración deseada
                count <= 0;
                state <= RED_YELLOW;
            end
        end
        RED_YELLOW: begin
            if(count >= 500000) begin // Ajustar según la duración deseada
                count <= 0;
                state <= GREEN;
            end
        end
        GREEN: begin
            if(count >= 1000000) begin // Ajustar según la duración deseada
                count <= 0;
                state <= GREEN_YELLOW;
            end
        end
        GREEN_YELLOW: begin
            if(count >= 500000) begin // Ajustar según la duración deseada
                count <= 0;
                state <= RED;
            end
        end
        default: begin
            state <= RED; // Estado por defecto
        end
    endcase
end

// Asignaciones concurrentes para controlar los LEDs
assign red = (state == RED) || (state == RED_YELLOW);
assign yellow = (state == YELLOW) || (state == RED_YELLOW) || (state == GREEN_YELLOW);
assign green = (state == GREEN);

endmodule

