(under development)

## Development

### Build

Prerequisites:

* [Ruby](https://www.ruby-lang.org/) (i.e. `ruby` and `bundle` on the `PATH`)
* [Rust](https://www.rust-lang.org/) (i.e. `cargo` on the `PATH`)
* [Protobuf Compiler](https://protobuf.dev/) (i.e. `protoc` on the `PATH`)
* This repository, cloned recursively

To build shared library for development use:

    bundle exec rake compile:dev

To build and test release:

    bundle exec rake

### Testing

To test:

    bundle exec rspec

Single test:

    bundle exec rspec -e "my test description"

### Code Formatting and Type Checking

This project uses rubocop:

    bundle exec rake rubocop:autocorrect

TODO(cretz): Type checking

### Proto Generation

    bundle exec rake proto:generate

## TODO

* Don't use SendableProc pattern, try Opaque
* Try to use wrap instead of TypedData