FROM ubuntu:22.04 AS builder
RUN apt-get update && \
    apt-get install -y cmake g++ git libgtest-dev libgmock-dev python3 && \
    rm -rf /var/lib/apt/lists/*

# Собираем и устанавливаем GTest и GMock
RUN cd /usr/src/googletest && \
    cmake -B build -DCMAKE_INSTALL_PREFIX=/usr && \
    cmake --build build && \
    cd build && \
    make install

WORKDIR /app
COPY . .
RUN rm -rf build && \
    cmake -B build && \
    cmake --build build --target matrix_calculator

FROM ubuntu:22.04
WORKDIR /app
COPY --from=builder /app/build/matrix_calculator .
CMD ["./matrix_calculator"]
