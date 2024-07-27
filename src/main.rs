#![no_std]
#![no_main]

fn a_function() -> i32 {
    42
}

#[link(name="c")]
extern "C" {
}

#[no_mangle]
fn main(argc: isize, _argv: *const *const u8) -> i32 {
    a_function()
}


#[panic_handler]
fn panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}

