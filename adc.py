import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from matplotlib.widgets import Button

# Parámetros y señales
Fs = 50
T = 1 / Fs
t_analog = np.linspace(0, 1, 1000)
f_signal = 5

signal_analog = np.sin(2 * np.pi * f_signal * t_analog)
t_sampled = np.arange(0, 1, T)
signal_sampled = np.sin(2 * np.pi * f_signal * t_sampled)

t_hold = np.sort(np.concatenate((t_sampled, t_analog)))
signal_hold = np.zeros_like(t_hold)
for i in range(len(t_hold)):
    if t_hold[i] < t_sampled[0]:
        signal_hold[i] = signal_sampled[0]
    else:
        idx = np.where(t_sampled <= t_hold[i])[0][-1]
        signal_hold[i] = signal_sampled[idx]

bits_adc = 8
num_levels = 2 ** bits_adc
min_signal = -1
max_signal = 1
q_level_size = (max_signal - min_signal) / num_levels

def quantify(samples):
    q = np.floor((samples - min_signal) / q_level_size) * q_level_size + min_signal + q_level_size / 2
    return np.clip(q, min_signal + q_level_size / 2, max_signal - q_level_size / 2)

def decimal_to_bin_array(val, bits=bits_adc):
    return np.array(list(np.binary_repr(int(val), width=bits))).astype(int)

levels = np.linspace(min_signal + q_level_size / 2, max_signal - q_level_size / 2, num_levels)

ytick_positions = levels[::max(1, num_levels // 64)]
ytick_labels = []
for val in ytick_positions:
    level_idx = np.digitize(val, levels) - 1
    bin_code = ''.join(decimal_to_bin_array(level_idx, bits=bits_adc).astype(str))
    label = f"{val:.4f} ({bin_code})"
    ytick_labels.append(label)

fig, axs = plt.subplots(3, 1, figsize=(14, 12), gridspec_kw={'height_ratios': [1, 1, 2]}, constrained_layout=True)
plt.subplots_adjust(left=0.22, bottom=0.17)
for ax in axs:
    ax.set_xlim(0,1)
    ax.grid(True)

axs[0].set_title("Señal analógica continua (detalle)")
axs[0].set_ylim(-1.2, 1.2)
line_analog, = axs[0].plot([], [], color='blue')

axs[1].set_title("Sample and Hold")
axs[1].set_ylim(-1.2, 1.2)
line_hold_analog, = axs[1].plot(t_analog, signal_analog, linestyle='--', color='gray', alpha=0.8)  # Línea sinusoidal gris de trazo
line_hold, = axs[1].step([], [], where='post', color='orange')

axs[2].set_title(f"Cuantificación y codificación (ADC {bits_adc} bits)")
axs[2].set_ylim(min_signal - q_level_size * 15, max_signal + q_level_size * 15)
axs[2].set_yticks(ytick_positions)
axs[2].set_yticklabels(ytick_labels, fontsize=6)
axs[2].grid(True)

stem_quant_markerline, stem_quant_stemlines, stem_quant_baseline = axs[2].stem([t_sampled[0]], [signal_sampled[0]],
                                                                             linefmt='red', markerfmt='ro', basefmt=" ", label='Cuantificado')
stem_code_markerline, stem_code_stemlines, stem_code_baseline = axs[2].stem([t_sampled[0]], [signal_sampled[0]],
                                                                            linefmt='green', markerfmt='go', basefmt=" ", label='Codificación binaria')

axs[2].legend(loc='upper right')
texts_bin = []

total_frames = len(t_analog)
paused = [False]
zoom_active = [False]

def onClickPause(event):
    if paused[0]:
        ani.resume()
        btn_pause.label.set_text("Pausar")
    else:
        ani.pause()
        btn_pause.label.set_text("Reanudar")
    paused[0] = not paused[0]

def onClickZoom(event):
    toolbar = fig.canvas.toolbar
    if toolbar.mode == 'zoom':
        toolbar.zoom()
        btn_zoom.label.set_text("Activar Zoom")
        zoom_active[0] = False
    else:
        toolbar.zoom()
        btn_zoom.label.set_text("Desactivar Zoom")
        zoom_active[0] = True

def update(frame):
    for txt in texts_bin:
        txt.remove()
    texts_bin.clear()

    current_time = t_analog[frame]

    line_analog.set_data(t_analog[:frame], signal_analog[:frame])

    hold_indices = np.where(t_hold <= current_time)[0]
    if hold_indices.size > 0:
        x_h = t_hold[hold_indices]
        y_h = signal_hold[hold_indices]
        line_hold.set_data(x_h, y_h)
    else:
        line_hold.set_data([], [])

    sampled_indices = np.where(t_sampled <= current_time)[0]
    if sampled_indices.size > 0:
        y_quant = quantify(signal_sampled[sampled_indices])

        stem_quant_markerline.set_data(t_sampled[sampled_indices], y_quant)
        stem_quant_stemlines.set_segments([[[xi, 0], [xi, yi]] for xi, yi in zip(t_sampled[sampled_indices], y_quant)])
        stem_quant_baseline.set_data([0, 1], [0, 0])

        stem_code_markerline.set_data(t_sampled[sampled_indices], y_quant)
        stem_code_stemlines.set_segments([[[xi, 0], [xi, yi]] for xi, yi in zip(t_sampled[sampled_indices], y_quant)])
        stem_code_baseline.set_data([0, 1], [0, 0])

        for i in range(len(sampled_indices)):
            level_index = np.digitize(y_quant[i], levels) - 1
            code_bin = decimal_to_bin_array(level_index, bits=bits_adc)
            code_str = ''.join(code_bin.astype(str))
            txt = axs[2].text(-0.02, y_quant[i], code_str, fontsize=6,
                              ha='right', va='center', rotation=0,
                              bbox=dict(facecolor='white', alpha=0.75))
            texts_bin.append(txt)
    else:
        stem_quant_markerline.set_data([], [])
        stem_quant_stemlines.set_segments([])
        stem_quant_baseline.set_data([], [])

        stem_code_markerline.set_data([], [])
        stem_code_stemlines.set_segments([])
        stem_code_baseline.set_data([], [])

    artists = [line_analog, line_hold,
               stem_quant_markerline, stem_quant_stemlines, stem_quant_baseline,
               stem_code_markerline, stem_code_stemlines, stem_code_baseline] + texts_bin
    return artists

ax_pause = plt.axes([0.25, 0.01, 0.2, 0.05])
btn_pause = Button(ax_pause, 'Pausar')
btn_pause.on_clicked(onClickPause)

ax_zoom = plt.axes([0.55, 0.01, 0.2, 0.05])
btn_zoom = Button(ax_zoom, 'Activar Zoom')
btn_zoom.on_clicked(onClickZoom)

ani = FuncAnimation(fig, update, frames=total_frames, interval=30, blit=True, repeat=False)

plt.show()
