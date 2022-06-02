use embedded_hal::blocking::i2c::{self, SevenBitAddress};
use i2c_linux::I2c;
use std::{fs::File, io, path::Path};

pub struct I2C(I2c<File>);

impl I2C {
    pub fn new<P>(device: P) -> io::Result<Self>
    where
        P: AsRef<Path>,
    {
        Ok(Self(I2c::from_path(device)?))
    }
}

impl i2c::Write<SevenBitAddress> for I2C {
    type Error = io::Error;

    fn write(&mut self, address: SevenBitAddress, bytes: &[u8]) -> Result<(), Self::Error> {
        self.0.smbus_set_slave_address(address.into(), false)?;

        for &byte in bytes.iter().skip(1) {
            self.0.smbus_write_byte_data(bytes[0], byte)?;
        }

        Ok(())
    }
}
