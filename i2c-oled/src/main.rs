mod i2c;

use embedded_graphics::{
    mono_font::{ascii::FONT_8X13_BOLD, MonoTextStyleBuilder},
    pixelcolor::BinaryColor,
    prelude::*,
    text::{Baseline, Text},
};
use i2c::I2C;
use ssd1306::{prelude::*, I2CDisplayInterface, Ssd1306};
use std::{env, fs, io, thread, time::Duration};

const FREQ_PATH: &str = "/sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq";

fn main() -> io::Result<()> {
    let args = env::args().collect::<Vec<_>>();
    assert_eq!(args.len(), 3);

    let i2c = I2C::new(format!("/dev/i2c-{}", args[1]))?;

    let mut display = Ssd1306::new(
        I2CDisplayInterface::new(i2c),
        DisplaySize128x32,
        DisplayRotation::Rotate0,
    )
    .into_buffered_graphics_mode();

    display.init().unwrap();

    let text_style = MonoTextStyleBuilder::new()
        .font(&FONT_8X13_BOLD)
        .background_color(BinaryColor::Off)
        .text_color(BinaryColor::On)
        .build();

    Text::with_baseline(
        "Freq: 0000 MHz",
        Point::new(8, 4),
        text_style,
        Baseline::Top,
    )
    .draw(&mut display)
    .unwrap();

    Text::with_baseline(
        "Temp: 00.000 C",
        Point::new(8, 18),
        text_style,
        Baseline::Top,
    )
    .draw(&mut display)
    .unwrap();

    loop {
        let freq = fs::read_to_string(FREQ_PATH)?;
        let freq = freq.trim().parse::<usize>().unwrap() / 1000;
        let freq = format!("{freq:04}");

        Text::with_baseline(&freq, Point::new(56, 4), text_style, Baseline::Top)
            .draw(&mut display)
            .unwrap();

        let temp = fs::read_to_string(&args[2])?;
        let temp = temp.trim().parse::<usize>().unwrap();
        let temp = format!("{:02}.{:03}", temp / 1000, temp % 1000);

        Text::with_baseline(&temp, Point::new(56, 18), text_style, Baseline::Top)
            .draw(&mut display)
            .unwrap();

        display.flush().unwrap();

        thread::sleep(Duration::from_secs(1));
    }
}
