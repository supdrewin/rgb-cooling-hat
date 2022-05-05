mod i2c;

use i2c::I2C;
use ssd1306::{prelude::*, I2CDisplayInterface};
use std::{env, fmt::Write, fs, io, thread, time::Duration};

fn main() -> io::Result<()> {
    let args = env::args().collect::<Vec<_>>();
    assert_eq!(args.len(), 3);

    let i2c = I2C::new(format!("/dev/i2c-{}", args[1]))?;

    let mut display = ssd1306::Ssd1306::new(
        I2CDisplayInterface::new(i2c),
        DisplaySize128x32,
        DisplayRotation::Rotate0,
    )
    .into_terminal_mode();

    display.init().expect("Failed to init display");

    loop {
        let temp = fs::read_to_string(&args[2])?;
        let i = temp.len() - 3;

        display.clear().expect("Failed to clear screen");

        write!(display, "Temp: {}.{} C", &temp[..i], &temp[i..])
            .expect("Failed to write formatted data");

        thread::sleep(Duration::from_secs(1));
    }
}
