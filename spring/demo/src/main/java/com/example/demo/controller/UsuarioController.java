package com.example.demo.controller;

import com.example.demo.exception.NotFoundException;
import com.example.demo.model.Usuario;
import com.example.demo.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = {"/user", "/usuario"})
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @GetMapping
    public List<Usuario> findAll() {
        return usuarioRepository.findAll();
    }

    @GetMapping("{id}")
    public Usuario findById(@PathVariable("id") Long id){
        return usuarioRepository.findById(id).orElseThrow(() -> new NotFoundException());
    }

    @PostMapping()
    public Boolean insert(@RequestBody Usuario usuario){
        usuarioRepository.save(usuario);
        return Boolean.TRUE;
    }

}
